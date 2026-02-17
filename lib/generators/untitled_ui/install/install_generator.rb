# frozen_string_literal: true

module UntitledUi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Install UntitledUi into your Rails application"

      def copy_color_template
        copy_file "untitled_ui_colors.css", "app/assets/tailwind/untitled_ui_colors.css"
      end

      def create_css_symlinks
        gem_root = UntitledUi.gem_root
        tailwind_dir = "app/assets/tailwind"

        {
          "untitled_ui" => gem_root.join("app", "assets", "tailwind", "untitled_ui"),
          "untitled_ui_components" => gem_root.join("app", "components"),
          "untitled_ui_views" => gem_root.join("app", "views")
        }.each do |name, target|
          link = File.join(tailwind_dir, name)
          if File.exist?(link)
            say_status :skip, "#{link} (already exists)", :yellow
          else
            create_link link, target
          end
        end
      end

      def add_css_imports
        css_file = "app/assets/tailwind/application.css"
        return unless File.exist?(css_file)

        imports = <<~CSS

@import "./untitled_ui/theme.css";
@import "./untitled_ui/typography.css";
@import "./untitled_ui/globals.css";
/* Scan UntitledUi gem templates for Tailwind classes (via symlinks) */
@source "./untitled_ui_components/**/*.{erb,rb}";
@source "./untitled_ui_views/**/*.erb";
        CSS

        inject_into_file css_file, imports, after: '@import "tailwindcss";'
      end

      def mount_engine
        route 'mount UntitledUi::Engine => "/design_system"'
      end

      def add_stimulus_controllers
        js_file = "app/javascript/controllers/index.js"
        return unless File.exist?(js_file)

        registration = <<~JS

          // UntitledUi Stimulus controllers
          import CheckboxController from "untitled_ui/checkbox_controller"
          import DropdownController from "untitled_ui/dropdown_controller"
          import ModalController from "untitled_ui/modal_controller"
          import NavigationMobileController from "untitled_ui/navigation_mobile_controller"
          import NavigationSidebarController from "untitled_ui/navigation_sidebar_controller"
          import TabsController from "untitled_ui/tabs_controller"
          import ToggleController from "untitled_ui/toggle_controller"
          import TooltipController from "untitled_ui/tooltip_controller"
          application.register("checkbox", CheckboxController)
          application.register("dropdown", DropdownController)
          application.register("modal", ModalController)
          application.register("navigation-mobile", NavigationMobileController)
          application.register("navigation-sidebar", NavigationSidebarController)
          application.register("tabs", TabsController)
          application.register("toggle", ToggleController)
          application.register("tooltip", TooltipController)
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
