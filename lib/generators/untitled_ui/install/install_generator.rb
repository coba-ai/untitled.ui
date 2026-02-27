# frozen_string_literal: true

require "fileutils"
require "pathname"

module UntitledUi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Install UntitledUi into your Rails application"

      TAILWIND_REQUIRED_LINES = [
        '@import "./untitled_ui/theme.css";',
        '@import "./untitled_ui/typography.css";',
        '@import "./untitled_ui/globals.css";',
        '@source "./untitled_ui_components/**/*.erb";',
        '@source "./untitled_ui_views/**/*.erb";',
        '@source "./untitled_ui_components/**/*.rb";'
      ].freeze

      def copy_color_template
        copy_file "untitled_ui_colors.css", "app/assets/tailwind/untitled_ui_colors.css"
      end

      def copy_tailwind_assets
        destination = app_path("app/assets/tailwind/untitled_ui")
        if destination.symlink?
          remove_file(destination.to_s)
          say_status :remove, "#{destination} (replacing symlink with local directory)", :yellow
        end

        copy_tree(
          source_dir: UntitledUi.gem_root.join("app", "assets", "tailwind", "untitled_ui"),
          destination_dir: destination,
          only_extensions: [".css"]
        )
      end

      def copy_component_templates
        copy_tree(
          source_dir: UntitledUi.gem_root.join("app", "components", "ui"),
          destination_dir: app_path("app/components/ui")
        )
      end

      def copy_view_templates
        copy_tree(
          source_dir: UntitledUi.gem_root.join("app", "views", "untitled_ui"),
          destination_dir: app_path("app/views/untitled_ui"),
          only_extensions: [".erb"]
        )
      end

      def create_tailwind_scan_symlinks
        tailwind_dir = app_path("app/assets/tailwind")
        return unless tailwind_dir.directory?

        {
          "untitled_ui_components" => app_path("app/components"),
          "untitled_ui_views" => app_path("app/views")
        }.each do |name, target|
          link = tailwind_dir.join(name)

          if link.symlink?
            if link.readlink.to_s == target.to_s
              say_status :skip, "#{link} (already linked)", :yellow
            else
              remove_file(link.to_s)
              create_link(link.to_s, target.to_s)
            end
          elsif link.exist?
            say_status :skip, "#{link} (already exists)", :yellow
          else
            create_link(link.to_s, target.to_s)
          end
        end
      end

      def add_css_imports
        css_file = app_path("app/assets/tailwind/application.css")
        ensure_tailwind_entrypoint!(css_file)

        content = css_file.read
        missing_lines = TAILWIND_REQUIRED_LINES.reject { |line| content.include?(line) }
        return if missing_lines.empty?

        insertion = missing_lines.join("\n")
        updated = if content.match?(/@import\s+["']tailwindcss["'][^;]*;/)
                    content.sub(/@import\s+["']tailwindcss["'][^;]*;/) { |match| "#{match}\n#{insertion}" }
                  else
                    "#{content.rstrip}\n\n#{insertion}\n"
                  end

        css_file.write(updated)
        say_status :insert, css_file.to_s, :green
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
        say "  2. Review generated templates in app/components/ui and app/views/untitled_ui"
        say "  3. Visit /design_system to browse components"
        say "  4. Use components in views:"
        say "     render Ui::Button::Component.new(color: :primary) { 'Click me' }"
        say "     render Ui::Input::Component.new(label: 'Email')"
        say ""
      end

      private

      def copy_tree(source_dir:, destination_dir:, only_extensions: nil)
        source_path = Pathname.new(source_dir)
        return unless source_path.directory?

        Dir.glob(source_path.join("**/*").to_s).sort.each do |source|
          source_file = Pathname.new(source)
          next if source_file.directory?
          next if only_extensions && !only_extensions.include?(source_file.extname)

          relative_path = source_file.relative_path_from(source_path)
          target_file = destination_dir.join(relative_path)
          FileUtils.mkdir_p(target_file.dirname)

          if target_file.exist?
            say_status :skip, "#{target_file} (already exists)", :yellow
          else
            FileUtils.cp(source_file, target_file)
            say_status :copy, target_file.to_s, :green
          end
        end
      end

      def app_path(relative_path)
        Pathname.new(File.join(destination_root, relative_path))
      end

      def ensure_tailwind_entrypoint!(css_file)
        return if css_file.exist?

        FileUtils.mkdir_p(css_file.dirname)
        css_file.write("@import \"tailwindcss\";\n")
        say_status :create, css_file.to_s, :green
      end
    end
  end
end
