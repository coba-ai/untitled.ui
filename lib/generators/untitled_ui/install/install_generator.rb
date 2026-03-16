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
        '@import "./untitled_ui/hacker.css";',
        '@import "./untitled_ui_colors.css";',
        '@source "../../components/**/*.erb";',
        '@source "../../components/**/*.rb";',
        '@source "../../views/**/*.erb";'
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
          only_extensions: [".css"],
          overwrite: true
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
          only_extensions: [".erb"],
          overwrite: true
        )
      end

      def copy_layout_templates
        copy_tree(
          source_dir: UntitledUi.gem_root.join("app", "views", "layouts", "untitled_ui"),
          destination_dir: app_path("app/views/layouts/untitled_ui"),
          only_extensions: [".erb"],
          overwrite: true
        )
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
        if importmap?
          add_importmap_controllers
        elsif node_bundler?
          copy_controllers_for_bundler
        else
          say_status :skip, "No supported JS setup detected (importmap or package.json)", :yellow
        end
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
        bundler_name = if importmap?
                         "importmap"
                       elsif node_bundler?
                         "node (esbuild/Vite/Webpack)"
                       else
                         "none"
                       end
        say "JS bundler detected: #{bundler_name}"
        say ""
      end

      STIMULUS_BLOCK_START = "// UntitledUi Stimulus controllers"
      STIMULUS_BLOCK_END = 'application.register("tooltip", TooltipController)'
      VALID_IMPORT_PREFIXES = %w[untitled_ui ./untitled_ui].freeze

      private

      def copy_tree(source_dir:, destination_dir:, only_extensions: nil, overwrite: false)
        source_path = Pathname.new(source_dir)
        return unless source_path.directory?

        Dir.glob(source_path.join("**/*").to_s).each do |source|
          source_file = Pathname.new(source)
          next if source_file.directory?
          next if only_extensions && !only_extensions.include?(source_file.extname)

          relative_path = source_file.relative_path_from(source_path)
          target_file = destination_dir.join(relative_path)
          FileUtils.mkdir_p(target_file.dirname)

          if target_file.exist?
            if overwrite
              FileUtils.cp(source_file, target_file)
              say_status :update, target_file.to_s, :green
            else
              say_status :skip, "#{target_file} (already exists)", :yellow
            end
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

      def importmap?
        File.exist?(File.join(destination_root, "config", "importmap.rb"))
      end

      def node_bundler?
        File.exist?(File.join(destination_root, "package.json"))
      end

      def stimulus_registration(import_prefix)
        raise ArgumentError, "Invalid import prefix: #{import_prefix}" unless VALID_IMPORT_PREFIXES.include?(import_prefix)

        <<~JS

          #{STIMULUS_BLOCK_START}
          import CheckboxController from "#{import_prefix}/checkbox_controller"
          import DropdownController from "#{import_prefix}/dropdown_controller"
          import ModalController from "#{import_prefix}/modal_controller"
          import NavigationMobileController from "#{import_prefix}/navigation_mobile_controller"
          import NavigationSidebarController from "#{import_prefix}/navigation_sidebar_controller"
          import TabsController from "#{import_prefix}/tabs_controller"
          import ToggleController from "#{import_prefix}/toggle_controller"
          import TooltipController from "#{import_prefix}/tooltip_controller"
          application.register("checkbox", CheckboxController)
          application.register("dropdown", DropdownController)
          application.register("modal", ModalController)
          application.register("navigation-mobile", NavigationMobileController)
          application.register("navigation-sidebar", NavigationSidebarController)
          application.register("tabs", TabsController)
          application.register("toggle", ToggleController)
          #{STIMULUS_BLOCK_END}
        JS
      end

      def replace_or_append_stimulus_registration(js_path, import_prefix)
        return unless File.exist?(File.join(destination_root, js_path))

        content = File.read(File.join(destination_root, js_path))

        if content.include?(STIMULUS_BLOCK_START)
          # Replace existing block (handles bundler switches)
          updated = content.sub(
            /\n*#{Regexp.escape(STIMULUS_BLOCK_START)}.*?#{Regexp.escape(STIMULUS_BLOCK_END)}\n*/m,
            stimulus_registration(import_prefix)
          )
          File.write(File.join(destination_root, js_path), updated)
          say_status :update, "#{js_path} (replaced UntitledUi controllers)", :green
        else
          append_to_file js_path, stimulus_registration(import_prefix)
        end
      end

      def add_importmap_controllers
        replace_or_append_stimulus_registration("app/javascript/controllers/index.js", "untitled_ui")
      end

      def copy_controllers_for_bundler
        source_js = UntitledUi.gem_root.join("app", "javascript", "untitled_ui")
        dest_js = app_path("app/javascript/controllers/untitled_ui")

        copy_tree(
          source_dir: source_js,
          destination_dir: dest_js,
          only_extensions: [".js"],
          overwrite: false
        )

        replace_or_append_stimulus_registration("app/javascript/controllers/index.js", "./untitled_ui")
      end
    end
  end
end
