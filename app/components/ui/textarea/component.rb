# frozen_string_literal: true

module Ui
  module Textarea
    class Component < Ui::Base
      attr_reader :label, :hint, :placeholder, :required, :invalid, :disabled,
                  :name, :value, :rows, :cols, :extra_classes, :textarea_class

      def initialize(label: nil, hint: nil, placeholder: nil, required: false, invalid: false,
                     disabled: false, name: nil, value: nil, rows: 4, cols: nil,
                     textarea_class: nil, class: nil, **_opts)
        @label = label
        @hint = hint
        @placeholder = placeholder
        @required = required
        @invalid = invalid
        @disabled = disabled
        @name = name
        @value = value
        @rows = rows
        @cols = cols
        @textarea_class = textarea_class
        @extra_classes = binding.local_variable_get(:class)
      end

      def textarea_classes
        cx(
          "w-full scroll-py-3 rounded-lg bg-primary px-3.5 py-3 text-md text-primary shadow-xs ring-1 ring-primary transition duration-100 ease-linear ring-inset placeholder:text-placeholder focus:outline-hidden",
          "focus:ring-2 focus:ring-brand",
          @disabled && "cursor-not-allowed bg-disabled_subtle text-disabled ring-disabled",
          @invalid && "ring-error_subtle",
          @invalid && "focus:ring-2 focus:ring-error",
          @textarea_class
        )
      end
    end
  end
end
