# frozen_string_literal: true

module UntitledUi
  class FormBuilder < ActionView::Helpers::FormBuilder
    def ui_input(method, **options)
      set_text_field_options!(method, options)
      @template.render(Ui::Input::Component.new(**options))
    end

    def ui_textarea(method, **options)
      set_text_field_options!(method, options)
      @template.render(Ui::Textarea::Component.new(**options))
    end

    def ui_checkbox(method, **options)
      set_boolean_field_options!(method, options)
      @template.render(Ui::Checkbox::Component.new(**options))
    end

    def ui_toggle(method, **options)
      set_boolean_field_options!(method, options)
      @template.render(Ui::Toggle::Component.new(**options))
    end

    def ui_radio_button(method, value:, **options)
      options[:id] ||= field_id(method, value)
      options[:name] ||= field_name(method)
      options[:value] = value
      options[:checked] = (object_value(method).to_s == value.to_s) unless options.key?(:checked)
      options[:label] ||= value.to_s.humanize unless options.key?(:label)

      @template.render(Ui::RadioButton::Component.new(**options))
    end

    def ui_select(method, options:, **opts)
      set_text_field_options!(method, opts)
      opts[:options] = options
      opts[:value] ||= object_value(method)
      @template.render(Ui::Select::Component.new(**opts))
    end

    def ui_button(text = nil, **options, &block)
      options[:type] ||= "submit"
      content = text || (@template.capture(&block) if block) || "Submit"
      @template.render(Ui::Button::Component.new(**options)) { content }
    end

    private

    def set_text_field_options!(method, options)
      options[:id] ||= field_id(method)
      options[:name] ||= field_name(method)
      options[:value] = object_value(method) unless options.key?(:value)
      options[:invalid] = object_has_errors?(method) unless options.key?(:invalid)
      options[:hint] ||= error_message_for(method) if options[:invalid]
      options[:label] ||= method.to_s.humanize unless options.key?(:label)
    end

    def set_boolean_field_options!(method, options)
      options[:id] ||= field_id(method)
      options[:name] ||= field_name(method)
      options[:checked] = !!object_value(method) unless options.key?(:checked)
      options[:label] ||= method.to_s.humanize unless options.key?(:label)
    end

    def object_has_errors?(method)
      object&.respond_to?(:errors) && object.errors[method].any?
    end

    def error_message_for(method)
      return nil unless object_has_errors?(method)
      object.errors.full_messages_for(method).first
    end

    def object_value(method)
      return nil unless object&.respond_to?(method)
      object.public_send(method)
    end
  end
end
