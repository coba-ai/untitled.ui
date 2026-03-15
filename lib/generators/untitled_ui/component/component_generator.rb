# frozen_string_literal: true

require "fileutils"
require "pathname"

module UntitledUi
  module Generators
    class ComponentGenerator < Rails::Generators::Base
      desc "Copy specific UntitledUi components into your application for customization"

      argument :components, type: :array, banner: "component [component ...]"

      AVAILABLE_COMPONENTS = %w[
        avatar badge button button_group checkbox close_button dot_icon
        dropdown empty_state featured_icon hint_text input label
        loading_indicator modal pagination progress_bar progress_steps
        radio_button table tabs textarea toggle tooltip
        navigation/sidebar navigation/header navigation/mobile_header
        navigation/item navigation/item_button navigation/account_card
        navigation/list
      ].freeze

      SHARED_FILES = %w[
        base.rb
        class_names.rb
        concerns/has_variants.rb
      ].freeze

      def validate_components
        unknown = components - AVAILABLE_COMPONENTS
        return if unknown.empty?

        say_status :error, "Unknown component(s): #{unknown.join(', ')}", :red
        say ""
        say "Available components:"
        AVAILABLE_COMPONENTS.each { |c| say "  - #{c}" }
        raise Thor::Error, "Unknown component(s): #{unknown.join(', ')}"
      end

      def copy_shared_dependencies
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
        source_base = UntitledUi.gem_root.join("app", "components", "ui")
        dest_base = Pathname.new(File.join(destination_root, "app", "components", "ui"))

        components.each do |component|
          source_dir = source_base.join(component)
          dest_dir = dest_base.join(component)

          unless source_dir.directory?
            say_status :error, "Component directory not found: #{source_dir}", :red
            next
          end

          Dir.glob(source_dir.join("**/*").to_s).sort.each do |source|
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
