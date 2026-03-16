# frozen_string_literal: true

require "fileutils"
require "pathname"

module UntitledUi
  module Generators
    class ComponentGenerator < Rails::Generators::Base
      desc "Copy specific UntitledUi components into your application for customization"

      argument :components, type: :array, default: [], banner: "component [component ...]"

      class_option :list, type: :boolean, default: false, desc: "List all available components"

      COMPONENT_CATALOG = {
        "Actions" => %w[button button_group close_button dropdown],
        "Feedback" => %w[badge progress_bar loading_indicator empty_state],
        "Forms" => %w[input textarea checkbox toggle radio_button label hint_text],
        "Data Display" => %w[avatar table tabs dot_icon featured_icon],
        "Overlays" => %w[modal tooltip],
        "Navigation" => %w[
          navigation/sidebar navigation/header navigation/mobile_header
          navigation/item navigation/item_button navigation/account_card
          navigation/list
        ],
        "Layout" => %w[pagination progress_steps]
      }.freeze

      AVAILABLE_COMPONENTS = COMPONENT_CATALOG.values.flatten.freeze

      SHARED_FILES = %w[
        base.rb
        class_names.rb
        concerns/has_variants.rb
      ].freeze

      def handle_list
        return unless options[:list]

        say ""
        say "Available UntitledUi components:", :green
        say ""
        COMPONENT_CATALOG.each do |category, names|
          say "  #{category}:"
          names.each { |name| say "    - #{name}" }
          say ""
        end
        say "Usage: rails generate untitled_ui:component button modal tabs"
        say ""

        raise SystemExit
      end

      def validate_components
        if components.empty?
          say_status :error, "No components specified. Use --list to see available components.", :red
          raise Thor::Error, "No components specified"
        end

        unknown = components - AVAILABLE_COMPONENTS
        return if unknown.empty?

        say_status :error, "Unknown component(s): #{unknown.join(', ')}", :red
        say ""
        say "Run `rails generate untitled_ui:component --list` to see all available components."
        raise Thor::Error, "Unknown component(s): #{unknown.join(', ')}"
      end

      def copy_shared_dependencies
        return if options[:list]

        source_base = UntitledUi.gem_root.join("app", "components", "ui")
        dest_base = Pathname.new(File.join(destination_root, "app", "components", "ui"))

        SHARED_FILES.each do |file|
          source = source_base.join(file)
          target = dest_base.join(file)
          next unless source.exist?

          FileUtils.mkdir_p(target.dirname)
          unless target.exist?
            FileUtils.cp(source, target)
            say_status :copy, target.to_s, :green
          end
        end
      end

      def copy_components
        return if options[:list]

        source_base = UntitledUi.gem_root.join("app", "components", "ui")
        dest_base = Pathname.new(File.join(destination_root, "app", "components", "ui"))

        components.each do |component|
          source_dir = source_base.join(component)

          unless source_dir.directory?
            say_status :error, "Component directory not found: #{source_dir}", :red
            next
          end

          Dir.glob(source_dir.join("**/*").to_s).each do |source|
            source_file = Pathname.new(source)
            next if source_file.directory?

            relative = source_file.relative_path_from(source_base)
            target = dest_base.join(relative)
            FileUtils.mkdir_p(target.dirname)

            if target.exist?
              say_status :skip, "#{target} (already exists)", :yellow
            else
              FileUtils.cp(source_file, target)
              say_status :copy, target.to_s, :green
            end
          end
        end
      end

      def show_instructions
        return if options[:list]

        say ""
        say "Components copied successfully!", :green
        say ""
        say "Copied components can now be customized in app/components/ui/"
        say "The gem's version will be used as fallback for non-copied components."
        say ""
      end
    end
  end
end
