# frozen_string_literal: true

module Ui
  module ColorPicker
    class Component < Ui::Base
      WRAPPER_CLASSES = "relative flex w-full flex-row place-content-center place-items-center rounded-lg bg-primary shadow-xs ring-1 ring-primary transition-shadow duration-100 ease-linear ring-inset"
      DISPLAY_CLASSES = "m-0 w-full cursor-pointer bg-transparent text-md text-primary ring-0 outline-hidden placeholder:text-placeholder"

      DEFAULT_SWATCHES = %w[
        #000000 #FFFFFF #6B7280 #EF4444 #F97316 #EAB308
        #22C55E #14B8A6 #3B82F6 #8B5CF6 #EC4899 #F43F5E
      ].freeze

      attr_reader :name, :value, :label, :hint, :swatches, :required,
                  :invalid, :disabled, :id, :extra_classes

      def initialize(
        name: nil, value: "#000000", label: nil, hint: nil,
        swatches: nil, required: false, invalid: false, disabled: false,
        id: nil, class: nil, **_opts
      )
        @name = name
        @value = value.presence || "#000000"
        @label = label
        @hint = hint
        @swatches = swatches || DEFAULT_SWATCHES
        @required = required
        @invalid = invalid
        @disabled = disabled
        @id = id
        @extra_classes = binding.local_variable_get(:class)
      end

      def wrapper_classes
        cx(
          WRAPPER_CLASSES,
          "focus-within:ring-2 focus-within:ring-brand",
          @disabled && "cursor-not-allowed bg-disabled_subtle ring-disabled",
          @invalid && "ring-error_subtle",
          @invalid && "focus-within:ring-2 focus-within:ring-error"
        )
      end

      def trigger_classes
        cx(
          DISPLAY_CLASSES,
          "px-3 py-2 pr-3",
          @disabled && "cursor-not-allowed text-disabled"
        )
      end

      def normalized_value
        val = @value.to_s.strip
        val.start_with?("#") ? val : "##{val}"
      end
    end
  end
end
