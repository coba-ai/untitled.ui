# frozen_string_literal: true

module UntitledUi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Install UntitledUi into your Rails application"

      def copy_color_template
        copy_file "untitled_ui_colors.css", "app/assets/tailwind/untitled_ui_colors.css"
      end

      def add_css_imports
        css_file = "app/assets/tailwind/application.css"
        return unless File.exist?(css_file)

        imports = <<~CSS

          @import "untitled_ui/theme";
          @import "untitled_ui/typography";
          @import "untitled_ui/globals";
        CSS

        inject_into_file css_file, imports, after: '@import "tailwindcss";'
      end

      def add_tailwind_source
        css_file = "app/assets/tailwind/application.css"
        return unless File.exist?(css_file)

        gem_path = UntitledUi.gem_root.join("app", "components")
        source_line = "\n@source \"#{gem_path}/**/*.erb\";\n"

        append_to_file css_file, source_line
      end

      def mount_engine
        route 'mount UntitledUi::Engine => "/design_system"'
      end

      def add_stimulus_controllers
        js_file = "app/javascript/controllers/index.js"
        return unless File.exist?(js_file)

        registration = <<~JS

          // UntitledUi Stimulus controllers
          import { ModalController, DropdownController, TabsController, TooltipController, ToggleController, CheckboxController } from "untitled_ui"
          application.register("modal", ModalController)
          application.register("dropdown", DropdownController)
          application.register("tabs", TabsController)
          application.register("tooltip", TooltipController)
          application.register("toggle", ToggleController)
          application.register("checkbox", CheckboxController)
        JS

        append_to_file js_file, registration
      end

      def show_instructions
        say ""
        say "UntitledUi installed successfully!", :green
        say ""
        say "Next steps:"
        say "  1. Customize brand colors in app/assets/tailwind/untitled_ui_colors.css"
        say "  2. Visit /design_system to browse components"
        say "  3. Use components in views:"
        say "     render Ui::Button::Component.new(color: :primary) { 'Click me' }"
        say "     render Ui::Input::Component.new(label: 'Email')"
        say ""
      end
    end
  end
end
