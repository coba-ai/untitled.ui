# frozen_string_literal: true

require "rails_helper"
require "fileutils"
require "tmpdir"
require "rails/generators"
require "generators/untitled_ui/theme/theme_generator"

RSpec.describe UntitledUi::Generators::ThemeGenerator do
  def prepare_minimal_app!(root)
    FileUtils.mkdir_p(File.join(root, "app/assets/tailwind"))
    File.write(
      File.join(root, "app/assets/tailwind/application.css"),
      "@import \"tailwindcss\";\n"
    )
  end

  def run_generator!(root, theme_name, options = {})
    args = [theme_name]
    generator = described_class.new(args, options, {})
    generator.destination_root = root
    generator.invoke_all
  end

  describe "basic generation" do
    it "creates a theme CSS file with the correct class scope" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "corporate")

        css_path = File.join(root, "app/assets/tailwind/untitled_ui/corporate.css")
        expect(File.exist?(css_path)).to be(true)

        content = File.read(css_path)
        expect(content).to include(".corporate-theme")
      end
    end

    it "includes all five color scales with placeholder values" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "mytheme")

        content = File.read(File.join(root, "app/assets/tailwind/untitled_ui/mytheme.css"))

        %w[brand error warning success gray].each do |scale|
          expect(content).to include("--color-#{scale}-500:")
          expect(content).to include("--color-#{scale}-25:")
          expect(content).to include("--color-#{scale}-950:")
        end

        expect(content).to include("/* TODO: customize */")
      end
    end

    it "includes semantic text, border, foreground, and background color tokens" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "mytheme")

        content = File.read(File.join(root, "app/assets/tailwind/untitled_ui/mytheme.css"))

        expect(content).to include("--color-text-primary:")
        expect(content).to include("--color-border-primary:")
        expect(content).to include("--color-fg-primary:")
        expect(content).to include("--color-bg-primary:")
        expect(content).to include("--color-bg-brand-solid:")
      end
    end

    it "includes helpful comments explaining each color group" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "mytheme")

        content = File.read(File.join(root, "app/assets/tailwind/untitled_ui/mytheme.css"))

        expect(content).to include("BRAND COLORS")
        expect(content).to include("ERROR COLORS")
        expect(content).to include("WARNING COLORS")
        expect(content).to include("SUCCESS COLORS")
        expect(content).to include("GRAY COLORS")
        expect(content).to include("TEXT COLORS")
        expect(content).to include("BORDER COLORS")
        expect(content).to include("FOREGROUND COLORS")
        expect(content).to include("BACKGROUND COLORS")
      end
    end
  end

  describe "CSS import injection" do
    it "appends the theme import to application.css" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "corporate")

        css = File.read(File.join(root, "app/assets/tailwind/application.css"))
        expect(css).to include('@import "./untitled_ui/corporate.css";')
      end
    end

    it "does not duplicate imports when run twice" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "corporate")
        run_generator!(root, "corporate")

        css = File.read(File.join(root, "app/assets/tailwind/application.css"))
        expect(css.scan('@import "./untitled_ui/corporate.css";').length).to eq(1)
      end
    end

    it "does not modify application.css if the file does not exist" do
      Dir.mktmpdir do |root|
        FileUtils.mkdir_p(File.join(root, "app/assets/tailwind"))
        # No application.css created
        expect { run_generator!(root, "mytheme") }.not_to raise_error
        expect(File.exist?(File.join(root, "app/assets/tailwind/application.css"))).to be(false)
      end
    end
  end

  describe "preset option" do
    it "fills in curated color values for the corporate preset" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "corporate", preset: "corporate")

        content = File.read(File.join(root, "app/assets/tailwind/untitled_ui/corporate.css"))

        # Should have actual RGB values, not placeholders
        expect(content).not_to include("/* TODO: customize */")
        expect(content).to include("--color-brand-600: rgb(55 65 199);")
        expect(content).to include("--color-gray-950: rgb(13 15 28);")
      end
    end

    it "fills in curated color values for the ocean preset" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "ocean", preset: "ocean")

        content = File.read(File.join(root, "app/assets/tailwind/untitled_ui/ocean.css"))

        expect(content).not_to include("/* TODO: customize */")
        expect(content).to include("--color-brand-600: rgb(0 134 201);")
      end
    end

    it "fills in curated color values for the warm preset" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "warm", preset: "warm")

        content = File.read(File.join(root, "app/assets/tailwind/untitled_ui/warm.css"))

        expect(content).not_to include("/* TODO: customize */")
        expect(content).to include("--color-brand-600: rgb(224 79 22);")
      end
    end

    it "fills in curated color values for the dark preset" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "dark", preset: "dark")

        content = File.read(File.join(root, "app/assets/tailwind/untitled_ui/dark.css"))

        # Should have actual RGB values, not placeholders
        expect(content).not_to include("/* TODO: customize */")

        # Dark preset uses a slate-based blue brand
        expect(content).to include("--color-brand-600: rgb(3 105 161);")

        # Inverted gray scale — darkest values at high steps
        expect(content).to include("--color-gray-950: rgb(3 7 18);")
        expect(content).to include("--color-gray-25: rgb(248 250 252);")

        # Semantic tokens should be inverted for dark backgrounds
        expect(content).to include("--color-bg-primary: var(--color-gray-950)")
        expect(content).to include("--color-bg-secondary: var(--color-gray-900)")
        expect(content).to include("--color-text-primary: var(--color-gray-50)")
        expect(content).to include("--color-text-secondary: var(--color-gray-300)")
        expect(content).to include("--color-border-primary: var(--color-gray-700)")
      end
    end

    it "allows using a preset name different from the theme name" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "dark", preset: "corporate")

        css_path = File.join(root, "app/assets/tailwind/untitled_ui/dark.css")
        expect(File.exist?(css_path)).to be(true)

        content = File.read(css_path)
        expect(content).to include(".dark-theme")
        expect(content).to include("--color-brand-600: rgb(55 65 199);")
      end
    end

    it "raises an error for an unknown preset" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        expect { run_generator!(root, "mytheme", preset: "nonexistent") }.to raise_error(Thor::Error, /Unknown preset/)
      end
    end
  end

  describe "multiple themes" do
    it "supports generating multiple themes in the same app" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "corporate", preset: "corporate")
        run_generator!(root, "ocean", preset: "ocean")

        expect(File.exist?(File.join(root, "app/assets/tailwind/untitled_ui/corporate.css"))).to be(true)
        expect(File.exist?(File.join(root, "app/assets/tailwind/untitled_ui/ocean.css"))).to be(true)

        css = File.read(File.join(root, "app/assets/tailwind/application.css"))
        expect(css).to include('@import "./untitled_ui/corporate.css";')
        expect(css).to include('@import "./untitled_ui/ocean.css";')
      end
    end
  end
end
