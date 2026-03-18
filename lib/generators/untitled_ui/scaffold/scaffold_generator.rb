# frozen_string_literal: true

module UntitledUi
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      desc "Generate a new UntitledUi component scaffold"

      class_option :stimulus, type: :boolean, default: false,
                              desc: "Generate a Stimulus controller for this component"

      class_option :slots, type: :string, default: nil,
                           desc: "Comma-separated list of slots (e.g. --slots=header,footer)"

      class_option :props, type: :string, default: nil,
                           desc: "Comma-separated props with optional type " \
                                 "(e.g. --props=size:select:sm:md:lg,disabled:boolean)"

      def create_component_rb
        template "component.rb.tt", "app/components/ui/#{file_name}/component.rb"
      end

      def create_component_erb
        template "component.html.erb.tt", "app/components/ui/#{file_name}/component.html.erb"
      end

      def create_spec
        template "component_spec.rb.tt", "spec/components/ui/#{file_name}_component_spec.rb"
      end

      def create_example_partial
        template "example.html.erb.tt",
                 "app/views/untitled_ui/design_system/components/examples/_#{file_name}.html.erb"
      end

      def register_in_components_controller
        controller_path = "app/controllers/untitled_ui/design_system/components_controller.rb"
        full_path = File.join(destination_root, controller_path)
        return unless File.exist?(full_path)

        content = File.read(full_path)

        if content.include?("id: \"#{file_name}\"")
          say_status :skip, "#{controller_path} (#{file_name} already registered)", :yellow
          return
        end

        # Insert the new entry before the ].freeze line
        new_entry = "        { id: \"#{file_name}\", name: \"#{human_name}\", " \
                    "category: \"Base\",\n          description: \"#{human_name} component.\" }"
        updated = content.sub(/(\s*\]\.freeze)/) { ",\n#{new_entry}#{$1}" }
        File.write(full_path, updated)
        say_status :insert, "#{controller_path} (registered #{file_name})", :green
      end

      def create_stimulus_controller
        return unless options[:stimulus]

        template "stimulus_controller.js.tt",
                 "app/javascript/untitled_ui/#{file_name}_controller.js"
        register_stimulus_controller
      end

      def show_instructions
        say ""
        say "Component scaffold created successfully!", :green
        say ""
        say "Files generated:"
        say "  app/components/ui/#{file_name}/component.rb"
        say "  app/components/ui/#{file_name}/component.html.erb"
        say "  spec/components/ui/#{file_name}_component_spec.rb"
        say "  app/views/untitled_ui/design_system/components/examples/_#{file_name}.html.erb"
        say "  app/javascript/untitled_ui/#{file_name}_controller.js" if options[:stimulus]
        say ""
        say "Next steps:"
        say "  1. Implement your component logic in app/components/ui/#{file_name}/component.rb"
        say "  2. Style your template in app/components/ui/#{file_name}/component.html.erb"
        say "  3. Add examples in the design system partial"
        say "  4. Visit /design_system/components/#{file_name} to preview"
        say ""
      end

      private

      def slot_names
        return [] if options[:slots].blank?

        options[:slots].split(",").map(&:strip).reject(&:empty?)
      end

      # Returns array of hashes: [{ name: String, type: String, values: [String] }]
      def parsed_props
        return [] if options[:props].blank?

        options[:props].split(",").map do |prop_str|
          parts = prop_str.strip.split(":")
          { name: parts[0], type: parts[1] || "string", values: parts[2..] || [] }
        end
      end

      def boolean_props
        parsed_props.select { |p| p[:type] == "boolean" }
      end

      def select_props
        parsed_props.select { |p| p[:type] == "select" }
      end

      def string_props
        parsed_props.select { |p| p[:type] == "string" }
      end

      def all_props
        parsed_props
      end

      # Build the initialize argument list as a string fragment
      def initialize_args
        args = all_props.map do |prop|
          if prop[:type] == "boolean"
            "#{prop[:name]}: false, "
          elsif prop[:type] == "select" && prop[:values].any?
            "#{prop[:name]}: :#{prop[:values].first}, "
          else
            "#{prop[:name]}: nil, "
          end
        end
        args.join
      end

      def module_name
        file_name.camelize
      end

      def component_class_name
        "Ui::#{module_name}::Component"
      end

      def stimulus_identifier
        file_name.tr("_", "-")
      end

      def human_name
        file_name.split("_").map(&:capitalize).join(" ")
      end

      def register_stimulus_controller
        index_path = "app/javascript/untitled_ui/index.js"
        full_index = File.join(destination_root, index_path)
        return unless File.exist?(full_index)

        content = File.read(full_index)
        controller_class = "#{module_name}Controller"
        import_line = "import #{controller_class} from \"untitled_ui/#{file_name}_controller\""
        identifier = stimulus_identifier

        if content.include?(import_line)
          say_status :skip, "#{index_path} (#{identifier} already registered)", :yellow
          return
        end

        updated = content.dup

        # 1. Add import before "const controllerDefinitions"
        updated = updated.sub(
          /^(const controllerDefinitions)/,
          "#{import_line}\n\\1"
        )

        # 2. Append to controllerDefinitions array (before closing bracket)
        updated = updated.sub(
          /(\]\s*\n\nconst application)/m,
          "  [\"#{identifier}\", #{controller_class}]\n]\n\nconst application"
        )

        # 3. Append to export block (before closing brace)
        updated = updated.sub(/(\}\s*\z)/m) do
          "  #{controller_class}\n}\n"
        end

        File.write(full_index, updated)
        say_status :insert, "#{index_path} (registered #{identifier})", :green
      end
    end
  end
end
