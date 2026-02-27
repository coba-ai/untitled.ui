# frozen_string_literal: true

require "rails_helper"
require "fileutils"
require "tmpdir"
require "rails/generators"
require "generators/untitled_ui/install/install_generator"

RSpec.describe UntitledUi::Generators::InstallGenerator do
  def prepare_minimal_app!(root, tailwind_import: '@import "tailwindcss";', create_tailwind_css: true)
    FileUtils.mkdir_p(File.join(root, "app/assets/tailwind"))
    if create_tailwind_css
      File.write(File.join(root, "app/assets/tailwind/application.css"), "#{tailwind_import}\n")
    end

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

  it "installs ui templates in app/components and adds required tailwind directives" do
    Dir.mktmpdir do |root|
      prepare_minimal_app!(root)
      run_install!(root)

      expect(File.exist?(File.join(root, "app/components/ui/button/component.rb"))).to be(true)
      expect(File.exist?(File.join(root, "app/components/ui/button/component.html.erb"))).to be(true)
      expect(File.exist?(File.join(root, "app/views/untitled_ui/design_system/components/index.html.erb"))).to be(true)
      expect(File.exist?(File.join(root, "app/assets/tailwind/untitled_ui/theme.css"))).to be(true)

      css = File.read(File.join(root, "app/assets/tailwind/application.css"))
      expect(css).to include('@import "./untitled_ui/theme.css";')
      expect(css).to include('@import "./untitled_ui/typography.css";')
      expect(css).to include('@import "./untitled_ui/globals.css";')
      expect(css).to include('@source "./untitled_ui_components/**/*.erb";')
      expect(css).to include('@source "./untitled_ui_views/**/*.erb";')

      components_link = File.join(root, "app/assets/tailwind/untitled_ui_components")
      views_link = File.join(root, "app/assets/tailwind/untitled_ui_views")
      expect(File.symlink?(components_link)).to be(true)
      expect(File.symlink?(views_link)).to be(true)
      expect(File.realpath(components_link)).to eq(File.realpath(File.join(root, "app/components")))
      expect(File.realpath(views_link)).to eq(File.realpath(File.join(root, "app/views")))
    end
  end

  it "injects imports when tailwind import has source(none) syntax" do
    Dir.mktmpdir do |root|
      prepare_minimal_app!(root, tailwind_import: '@import "tailwindcss" source(none);')
      run_install!(root)

      css = File.read(File.join(root, "app/assets/tailwind/application.css"))
      expect(css).to include('@import "./untitled_ui/theme.css";')
      expect(css).to include('@source "./untitled_ui_components/**/*.erb";')
    end
  end

  it "creates a missing tailwind entrypoint and injects required untitled_ui directives" do
    Dir.mktmpdir do |root|
      prepare_minimal_app!(root, create_tailwind_css: false)
      run_install!(root)

      css = File.read(File.join(root, "app/assets/tailwind/application.css"))
      expect(css).to include('@import "tailwindcss";')
      expect(css).to include('@import "./untitled_ui/theme.css";')
      expect(css).to include('@source "./untitled_ui_components/**/*.erb";')
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

  it "updates untitled_ui design system view templates on reinstall" do
    Dir.mktmpdir do |root|
      prepare_minimal_app!(root)
      run_install!(root)

      view_path = File.join(root, "app/views/untitled_ui/design_system/components/show.html.erb")
      File.write(view_path, "<!-- stale -->\n")

      run_install!(root)

      view = File.read(view_path)
      expect(view).not_to include("<!-- stale -->")
      expect(view).to include("<h1 class=\"text-display-sm font-semibold text-primary\">")
    end
  end
end
