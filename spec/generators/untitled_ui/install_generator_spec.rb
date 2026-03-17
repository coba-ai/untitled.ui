# frozen_string_literal: true

require "rails_helper"
require "fileutils"
require "tmpdir"
require "rails/generators"
require "generators/untitled_ui/install/install_generator"

RSpec.describe UntitledUi::Generators::InstallGenerator do
  def prepare_minimal_app!(root, tailwind_import: '@import "tailwindcss";', create_tailwind_css: true)
    FileUtils.mkdir_p(File.join(root, "app/assets/tailwind"))
    File.write(File.join(root, "app/assets/tailwind/application.css"), "#{tailwind_import}\n") if create_tailwind_css

    FileUtils.mkdir_p(File.join(root, "app/javascript/controllers"))
    File.write(
      File.join(root, "app/javascript/controllers/index.js"),
      <<~JS
        import { application } from "controllers/application"
      JS
    )

    FileUtils.mkdir_p(File.join(root, "config"))
    File.write(
      File.join(root, "config/routes.rb"),
      <<~RUBY
        Rails.application.routes.draw do
        end
      RUBY
    )
  end

  def run_install!(root)
    generator = described_class.new([], {}, {})
    generator.destination_root = root
    generator.invoke_all
  end

  it "installs assets, views, and sources.css but does NOT copy components" do
    Dir.mktmpdir do |root|
      prepare_minimal_app!(root)
      run_install!(root)

      # Components are NOT copied — they're served from the gem
      expect(File.exist?(File.join(root, "app/components/ui/button/component.rb"))).to be(false)
      expect(File.exist?(File.join(root, "app/components/ui/button/component.html.erb"))).to be(false)

      # Only example partials are copied — layout and index/show come from the gem
      expect(File.exist?(File.join(root, "app/views/untitled_ui/design_system/components/examples/_button.html.erb"))).to be(true)
      expect(File.exist?(File.join(root, "app/views/untitled_ui/design_system/components/index.html.erb"))).to be(false)
      expect(File.exist?(File.join(root, "app/views/layouts/untitled_ui/design_system.html.erb"))).to be(false)
      expect(File.exist?(File.join(root, "app/assets/tailwind/untitled_ui/theme.css"))).to be(true)

      # sources.css is generated with relative path (not absolute)
      sources = File.read(File.join(root, "app/assets/tailwind/untitled_ui/sources.css"))
      expect(sources).to include('@source "')
      expect(sources).to include("/**/*.erb")
      expect(sources).to include("/**/*.rb")
      expect(sources).not_to match(%r{@source "/}) # no absolute paths

      css = File.read(File.join(root, "app/assets/tailwind/application.css"))
      expect(css).to include('@import "./untitled_ui/theme.css";')
      expect(css).to include('@import "./untitled_ui/typography.css";')
      expect(css).to include('@import "./untitled_ui/globals.css";')
      expect(css).to include('@import "./untitled_ui/hacker.css";')
      expect(css).to include('@import "./untitled_ui/sources.css";')
      expect(css).to include('@import "./untitled_ui_colors.css";')
      expect(css).to include('@source "../../components/**/*.erb";')
      expect(css).to include('@source "../../components/**/*.rb";')
      expect(css).to include('@source "../../views/**/*.erb";')
    end
  end

  it "regenerates sources.css on reinstall without prompting" do
    Dir.mktmpdir do |root|
      prepare_minimal_app!(root)
      run_install!(root)

      sources_path = File.join(root, "app/assets/tailwind/untitled_ui/sources.css")
      expect(File.exist?(sources_path)).to be(true)

      # Reinstall should overwrite without issue
      run_install!(root)
      expect(File.exist?(sources_path)).to be(true)
    end
  end

  it "warns about existing local components on install" do
    Dir.mktmpdir do |root|
      prepare_minimal_app!(root)

      # Simulate pre-existing local components (from old install)
      FileUtils.mkdir_p(File.join(root, "app/components/ui/button"))
      File.write(File.join(root, "app/components/ui/button/component.rb"), "# custom\n")

      # Should not raise, just warn
      expect { run_install!(root) }.not_to raise_error
    end
  end

  it "injects imports when tailwind import has source(none) syntax" do
    Dir.mktmpdir do |root|
      prepare_minimal_app!(root, tailwind_import: '@import "tailwindcss" source(none);')
      run_install!(root)

      css = File.read(File.join(root, "app/assets/tailwind/application.css"))
      expect(css).to include('@import "./untitled_ui/theme.css";')
      expect(css).to include('@import "./untitled_ui_colors.css";')
      expect(css).to include('@source "../../components/**/*.erb";')
    end
  end

  it "creates a missing tailwind entrypoint and injects required untitled_ui directives" do
    Dir.mktmpdir do |root|
      prepare_minimal_app!(root, create_tailwind_css: false)
      run_install!(root)

      css = File.read(File.join(root, "app/assets/tailwind/application.css"))
      expect(css).to include('@import "tailwindcss";')
      expect(css).to include('@import "./untitled_ui/theme.css";')
      expect(css).to include('@import "./untitled_ui_colors.css";')
      expect(css).to include('@source "../../components/**/*.erb";')
    end
  end

  it "replaces old untitled_ui tailwind symlink with a local directory copy" do
    Dir.mktmpdir do |root|
      prepare_minimal_app!(root)

      tailwind_dir = File.join(root, "app/assets/tailwind")
      old_link = File.join(tailwind_dir, "untitled_ui")
      File.symlink(File.join(UntitledUi.gem_root, "app/assets/tailwind/untitled_ui"), old_link)

      run_install!(root)

      expect(File.symlink?(old_link)).to be(false)
      expect(File.exist?(File.join(old_link, "theme.css"))).to be(true)
    end
  end

  it "updates untitled_ui tailwind css files on reinstall" do
    Dir.mktmpdir do |root|
      prepare_minimal_app!(root)
      run_install!(root)

      globals_path = File.join(root, "app/assets/tailwind/untitled_ui/globals.css")
      File.write(globals_path, "/* stale */\n")

      run_install!(root)

      globals = File.read(globals_path)
      expect(globals).not_to include("/* stale */")
      expect(globals).to include("@custom-variant dark")
    end
  end

  it "updates example partials on reinstall" do
    Dir.mktmpdir do |root|
      prepare_minimal_app!(root)
      run_install!(root)

      example_path = File.join(root, "app/views/untitled_ui/design_system/components/examples/_button.html.erb")
      File.write(example_path, "<!-- stale -->\n")

      run_install!(root)

      content = File.read(example_path)
      expect(content).not_to include("<!-- stale -->")
    end
  end

  describe "bundler detection" do
    def prepare_importmap_app!(root)
      prepare_minimal_app!(root)
      File.write(File.join(root, "config/importmap.rb"), "# importmap config\n")
    end

    def prepare_node_app!(root)
      prepare_minimal_app!(root)
      File.write(File.join(root, "package.json"), '{"name": "test-app"}')
    end

    it "registers controllers via importmap when config/importmap.rb exists" do
      Dir.mktmpdir do |root|
        prepare_importmap_app!(root)
        run_install!(root)

        js = File.read(File.join(root, "app/javascript/controllers/index.js"))
        expect(js).to include('from "untitled_ui/checkbox_controller"')
        expect(js).to include('application.register("checkbox", CheckboxController)')
        expect(js).not_to include("./untitled_ui")
      end
    end

    it "copies JS files and uses relative imports for node bundlers" do
      Dir.mktmpdir do |root|
        prepare_node_app!(root)
        run_install!(root)

        js = File.read(File.join(root, "app/javascript/controllers/index.js"))
        expect(js).to include('from "./untitled_ui/checkbox_controller"')
        expect(js).to include('application.register("modal", ModalController)')

        expect(File.exist?(File.join(root, "app/javascript/controllers/untitled_ui/checkbox_controller.js"))).to be(true)
        expect(File.exist?(File.join(root, "app/javascript/controllers/untitled_ui/modal_controller.js"))).to be(true)
      end
    end

    it "skips JS registration when neither importmap nor package.json exists" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        # No importmap.rb, no package.json
        run_install!(root)

        js = File.read(File.join(root, "app/javascript/controllers/index.js"))
        expect(js).not_to include("untitled_ui")
      end
    end

    it "is idempotent — does not duplicate registrations on re-run" do
      Dir.mktmpdir do |root|
        prepare_importmap_app!(root)
        run_install!(root)
        run_install!(root)

        js = File.read(File.join(root, "app/javascript/controllers/index.js"))
        expect(js.scan("UntitledUi Stimulus controllers").length).to eq(1)
        expect(js.scan('application.register("checkbox"').length).to eq(1)
      end
    end

    it "replaces import paths when switching from importmap to node bundler" do
      Dir.mktmpdir do |root|
        # First install with importmap
        prepare_importmap_app!(root)
        run_install!(root)

        js = File.read(File.join(root, "app/javascript/controllers/index.js"))
        expect(js).to include('from "untitled_ui/checkbox_controller"')

        # Switch to node bundler
        FileUtils.rm(File.join(root, "config/importmap.rb"))
        File.write(File.join(root, "package.json"), '{"name": "test-app"}')
        run_install!(root)

        js = File.read(File.join(root, "app/javascript/controllers/index.js"))
        expect(js).to include('from "./untitled_ui/checkbox_controller"')
        expect(js).not_to include('from "untitled_ui/checkbox_controller"')
        expect(js.scan("UntitledUi Stimulus controllers").length).to eq(1)
      end
    end
  end
end
