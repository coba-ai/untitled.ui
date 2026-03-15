# frozen_string_literal: true

module UntitledUi
  class FormBuilder < ActionView::Helpers::FormBuilder
    def ui_input(method, **options)
      options[:name] ||= field_name(method)
      options[:value] ||= object_value_for_method(method)
      options[:invalid] = object_has_errors?(method) unless options.key?(:invalid)
      options[:hint] ||= error_message_for(method) if options[:invalid]
      options[:label] ||= method.to_s.humanize unless options.key?(:label)

      @template.render(Ui::Input::Component.new(**options))
    end

    def ui_textarea(method, **options)
      options[:name] ||= field_name(method)
      options[:value] ||= object_value_for_method(method)
      options[:invalid] = object_has_errors?(method) unless options.key?(:invalid)
      options[:hint] ||= error_message_for(method) if options[:invalid]
      options[:label] ||= method.to_s.humanize unless options.key?(:label)

      @template.render(Ui::Textarea::Component.new(**options))
    end

    def ui_checkbox(method, **options)
      options[:name] ||= field_name(method)
      options[:checked] = !!object_value_for_method(method) unless options.key?(:checked)
      options[:label] ||= method.to_s.humanize unless options.key?(:label)

      @template.render(Ui::Checkbox::Component.new(**options))
    end

    def ui_toggle(method, **options)
      options[:name] ||= field_name(method)
      options[:checked] = !!object_value_for_method(method) unless options.key?(:checked)
      options[:label] ||= method.to_s.humanize unless options.key?(:label)

      @template.render(Ui::Toggle::Component.new(**options))
    end

    def ui_radio_button(method, value:, **options)
      options[:name] ||= field_name(method)
      options[:value] = value
      options[:checked] = (object_value_for_method(method).to_s == value.to_s) unless options.key?(:checked)
      options[:label] ||= value.to_s.humanize unless options.key?(:label)

      @template.render(Ui::RadioButton::Component.new(**options))
    end

    def ui_button(text = nil, **options, &block)
      options[:type] ||= "submit"
      @template.render(Ui::Button::Component.new(**options)) { text || (block ? block.call : "Submit") }
    end

    private

    def field_name(method)
      object_name ? "#{object_name}[#{method}]" : method.to_s
    end

    def object_has_errors?(method)
      object&.respond_to?(:errors) && object.errors[method].any?
    end

    def error_message_for(method)
      return nil unless object_has_errors?(method)
      object.errors.full_messages_for(method).first
    end

    def object_value_for_method(method)
      return nil unless object&.respond_to?(method)
      object.public_send(method)
    end
  end
end
