# frozen_string_literal: true

module UntitledUi
  # Defines playground knobs/controls for interactive component previews.
  # Each config entry maps a component id to a list of configurable params,
  # the component class, and an optional content block template.
  class ComponentConfig
    Control = Data.define(:param, :type, :options, :default)

    REGISTRY = {
      "button" => {
        component_class: "Ui::Button::Component",
        content: true,
        controls: [
          Control.new(param: :text, type: :text, options: nil, default: "Button"),
          Control.new(param: :size, type: :select, options: %i[sm md lg xl], default: :sm),
          Control.new(param: :color, type: :select, options: %i[primary secondary tertiary link_gray link_color primary_destructive secondary_destructive tertiary_destructive link_destructive], default: :primary),
          Control.new(param: :disabled, type: :checkbox, options: nil, default: false),
          Control.new(param: :loading, type: :checkbox, options: nil, default: false)
        ]
      },
      "badge" => {
        component_class: "Ui::Badge::Component",
        content: true,
        controls: [
          Control.new(param: :text, type: :text, options: nil, default: "Badge"),
          Control.new(param: :type, type: :select, options: %i[pill_color badge_color badge_modern], default: :pill_color),
          Control.new(param: :size, type: :select, options: %i[sm md lg], default: :md),
          Control.new(param: :color, type: :select, options: %i[gray brand error warning success blue indigo purple pink orange], default: :gray),
          Control.new(param: :dot, type: :checkbox, options: nil, default: false)
        ]
      },
      "input" => {
        component_class: "Ui::Input::Component",
        content: false,
        controls: [
          Control.new(param: :size, type: :select, options: %i[sm md], default: :sm),
          Control.new(param: :label, type: :text, options: nil, default: "Label"),
          Control.new(param: :placeholder, type: :text, options: nil, default: "Enter text..."),
          Control.new(param: :disabled, type: :checkbox, options: nil, default: false),
          Control.new(param: :invalid, type: :checkbox, options: nil, default: false)
        ]
      },
      "toggle" => {
        component_class: "Ui::Toggle::Component",
        content: false,
        controls: [
          Control.new(param: :size, type: :select, options: %i[sm md], default: :sm),
          Control.new(param: :label, type: :text, options: nil, default: "Toggle me"),
          Control.new(param: :checked, type: :checkbox, options: nil, default: false),
          Control.new(param: :disabled, type: :checkbox, options: nil, default: false)
        ]
      }
    }.freeze

    def self.for(component_id)
      REGISTRY[component_id]
    end

    def self.playground_available?(component_id)
      REGISTRY.key?(component_id)
    end

    # Build component kwargs from request params, coercing types based on control definitions.
    def self.build_props(component_id, raw_params)
      config = REGISTRY[component_id]
      return {} unless config

      props = {}
      config[:controls].each do |control|
        next if control.param == :text # :text param is content, not a kwarg

        value = raw_params[control.param]
        props[control.param] = coerce(value, control)
      end
      props
    end

    # Extract the content/text value from params.
    def self.build_content(component_id, raw_params)
      config = REGISTRY[component_id]
      return nil unless config&.dig(:content)

      text_control = config[:controls].find { |c| c.param == :text }
      return nil unless text_control

      value = raw_params[:text]
      value.present? ? value.to_s : text_control.default.to_s
    end

    # Generate a code snippet showing how to render the component with current props.
    def self.code_snippet(component_id, props, content)
      config = REGISTRY[component_id]
      return "" unless config

      klass = config[:component_class]
      args = props.map do |k, v|
        val = v.is_a?(Symbol) ? ":#{v}" : v.inspect
        "#{k}: #{val}"
      end.join(", ")

      if content.present?
        args_str = args.empty? ? "" : "(#{args})"
        "render(#{klass}.new#{args_str}) { #{content.inspect} }"
      else
        args_str = args.empty? ? "" : "(#{args})"
        "render #{klass}.new#{args_str}"
      end
    end

    def self.coerce(value, control)
      case control.type
      when :select
        value.present? ? value.to_sym : control.default
      when :checkbox
        value == "1" || value == "true"
      when :text
        value.present? ? value.to_s : control.default.to_s
      else
        value || control.default
      end
    end

    private_class_method :coerce
  end
end
