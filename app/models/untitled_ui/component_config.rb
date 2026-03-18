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
      },
      "alert" => {
        component_class: "Ui::Alert::Component",
        content: false,
        controls: [
          Control.new(param: :variant, type: :select, options: %i[info success warning error], default: :info),
          Control.new(param: :title, type: :text, options: nil, default: "Alert title"),
          Control.new(param: :description, type: :text, options: nil, default: "This is an alert description."),
          Control.new(param: :dismissible, type: :checkbox, options: nil, default: false)
        ]
      },
      "avatar" => {
        component_class: "Ui::Avatar::Component",
        content: false,
        controls: [
          Control.new(param: :size, type: :select, options: %i[xs sm md lg xl], default: :md),
          Control.new(param: :initials, type: :text, options: nil, default: "AB")
        ]
      },
      "card" => {
        component_class: "Ui::Card::Component",
        content: true,
        controls: [
          Control.new(param: :text, type: :text, options: nil, default: "Card content goes here."),
          Control.new(param: :padding, type: :select, options: %i[sm md lg], default: :md),
          Control.new(param: :shadow, type: :select, options: %i[none sm md lg], default: :sm),
          Control.new(param: :border, type: :checkbox, options: nil, default: true),
          Control.new(param: :rounded, type: :checkbox, options: nil, default: true)
        ]
      },
      "checkbox" => {
        component_class: "Ui::Checkbox::Component",
        content: false,
        controls: [
          Control.new(param: :size, type: :select, options: %i[sm md], default: :sm),
          Control.new(param: :label, type: :text, options: nil, default: "Accept terms and conditions"),
          Control.new(param: :checked, type: :checkbox, options: nil, default: false),
          Control.new(param: :disabled, type: :checkbox, options: nil, default: false)
        ]
      },
      "close_button" => {
        component_class: "Ui::CloseButton::Component",
        content: false,
        controls: [
          Control.new(param: :size, type: :select, options: %i[sm md lg], default: :sm),
          Control.new(param: :theme, type: :select, options: %i[light dark], default: :light)
        ]
      },
      "date_picker" => {
        component_class: "Ui::DatePicker::Component",
        content: false,
        controls: [
          Control.new(param: :label, type: :text, options: nil, default: "Date"),
          Control.new(param: :placeholder, type: :text, options: nil, default: "Select date"),
          Control.new(param: :disabled, type: :checkbox, options: nil, default: false),
          Control.new(param: :invalid, type: :checkbox, options: nil, default: false)
        ]
      },
      "dot_icon" => {
        component_class: "Ui::DotIcon::Component",
        content: false,
        controls: [
          Control.new(param: :size, type: :select, options: %i[sm md lg], default: :md),
          Control.new(param: :color, type: :text, options: nil, default: "text-success-500")
        ]
      },
      "empty_state" => {
        component_class: "Ui::EmptyState::Component",
        content: false,
        controls: [
          Control.new(param: :size, type: :select, options: %i[sm md lg], default: :lg),
          Control.new(param: :title, type: :text, options: nil, default: "No results found"),
          Control.new(param: :description, type: :text, options: nil, default: "Try adjusting your search or filters.")
        ]
      },
      "featured_icon" => {
        component_class: "Ui::FeaturedIcon::Component",
        content: false,
        controls: [
          Control.new(param: :theme, type: :select, options: %i[light dark modern outline], default: :light),
          Control.new(param: :color, type: :select, options: %i[brand gray error warning success], default: :brand),
          Control.new(param: :size, type: :select, options: %i[sm md lg xl], default: :sm)
        ]
      },
      "file_upload" => {
        component_class: "Ui::FileUpload::Component",
        content: false,
        controls: [
          Control.new(param: :label, type: :text, options: nil, default: "Upload a file"),
          Control.new(param: :hint, type: :text, options: nil, default: "PNG, JPG, PDF up to 10MB"),
          Control.new(param: :disabled, type: :checkbox, options: nil, default: false),
          Control.new(param: :invalid, type: :checkbox, options: nil, default: false),
          Control.new(param: :multiple, type: :checkbox, options: nil, default: false)
        ]
      },
      "hint_text" => {
        component_class: "Ui::HintText::Component",
        content: true,
        controls: [
          Control.new(param: :text, type: :text, options: nil, default: "This is a hint for the field."),
          Control.new(param: :invalid, type: :checkbox, options: nil, default: false)
        ]
      },
      "label" => {
        component_class: "Ui::Label::Component",
        content: false,
        controls: [
          Control.new(param: :text, type: :text, options: nil, default: "Field label"),
          Control.new(param: :required, type: :checkbox, options: nil, default: false)
        ]
      },
      "loading_indicator" => {
        component_class: "Ui::LoadingIndicator::Component",
        content: false,
        controls: [
          Control.new(param: :type, type: :select, options: %i[line_simple line_spinner], default: :line_simple),
          Control.new(param: :size, type: :select, options: %i[sm md lg xl], default: :sm),
          Control.new(param: :label, type: :text, options: nil, default: "Loading...")
        ]
      },
      "progress_bar" => {
        component_class: "Ui::ProgressBar::Component",
        content: false,
        controls: [
          Control.new(param: :value, type: :number, options: nil, default: 60),
          Control.new(param: :label_position, type: :select, options: ["none", :above, :below, :inline], default: "none")
        ]
      },
      "radio_button" => {
        component_class: "Ui::RadioButton::Component",
        content: false,
        controls: [
          Control.new(param: :size, type: :select, options: %i[sm md], default: :sm),
          Control.new(param: :label, type: :text, options: nil, default: "Select this option"),
          Control.new(param: :checked, type: :checkbox, options: nil, default: false),
          Control.new(param: :disabled, type: :checkbox, options: nil, default: false)
        ]
      },
      "select" => {
        component_class: "Ui::Select::Component",
        content: false,
        static_props: {
          options: [
            { label: "Apple", value: "apple" },
            { label: "Banana", value: "banana" },
            { label: "Cherry", value: "cherry" }
          ]
        },
        controls: [
          Control.new(param: :label, type: :text, options: nil, default: "Choose an option"),
          Control.new(param: :placeholder, type: :text, options: nil, default: "Select..."),
          Control.new(param: :searchable, type: :checkbox, options: nil, default: false),
          Control.new(param: :disabled, type: :checkbox, options: nil, default: false),
          Control.new(param: :invalid, type: :checkbox, options: nil, default: false)
        ]
      },
      "stat" => {
        component_class: "Ui::Stat::Component",
        content: false,
        controls: [
          Control.new(param: :label, type: :text, options: nil, default: "Total revenue"),
          Control.new(param: :value, type: :text, options: nil, default: "$45,231"),
          Control.new(param: :change, type: :text, options: nil, default: "+20.1%"),
          Control.new(param: :period, type: :text, options: nil, default: "vs last month")
        ]
      },
      "textarea" => {
        component_class: "Ui::Textarea::Component",
        content: false,
        controls: [
          Control.new(param: :label, type: :text, options: nil, default: "Message"),
          Control.new(param: :placeholder, type: :text, options: nil, default: "Enter your message..."),
          Control.new(param: :disabled, type: :checkbox, options: nil, default: false),
          Control.new(param: :invalid, type: :checkbox, options: nil, default: false)
        ]
      },
      "toast" => {
        component_class: "Ui::Toast::Component",
        content: false,
        controls: [
          Control.new(param: :title, type: :text, options: nil, default: "Notification"),
          Control.new(param: :description, type: :text, options: nil, default: "Your changes have been saved."),
          Control.new(param: :variant, type: :select, options: %i[success error warning info], default: :info),
          Control.new(param: :dismissible, type: :checkbox, options: nil, default: true)
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

      # Start with any static props defined in the config (e.g. hardcoded options arrays).
      props = (config[:static_props] || {}).dup

      config[:controls].each do |control|
        # :text param is content when the component uses block content; otherwise it's a kwarg.
        next if control.param == :text && config[:content]

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
        if value.present?
          value == "none" ? nil : value.to_sym
        else
          control.default
        end
      when :checkbox
        value == "1" || value == "true"
      when :text
        value.present? ? value.to_s : control.default.to_s
      when :number
        value.present? ? value.to_i : control.default
      else
        value || control.default
      end
    end

    private_class_method :coerce
  end
end
