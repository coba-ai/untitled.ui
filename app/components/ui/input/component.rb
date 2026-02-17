# frozen_string_literal: true

module Ui
  module Input
    class Component < Ui::Base
      SIZE_STYLES = {
        sm: { root: "px-3 py-2", icon_leading: "left-3", icon_trailing: "right-3" },
        md: { root: "px-3.5 py-2.5", icon_leading: "left-3.5", icon_trailing: "right-3.5" }
      }.freeze

      WRAPPER_CLASSES = "relative flex w-full flex-row place-content-center place-items-center rounded-lg bg-primary shadow-xs ring-1 ring-primary transition-shadow duration-100 ease-linear ring-inset".freeze
      INPUT_CLASSES = "m-0 w-full bg-transparent text-md text-primary ring-0 outline-hidden placeholder:text-placeholder".freeze

      attr_reader :size, :label, :hint, :placeholder, :icon, :tooltip, :required,
                  :invalid, :disabled, :name, :value, :type, :extra_classes,
                  :input_class, :wrapper_class

      def initialize(
        size: :sm, label: nil, hint: nil, placeholder: nil, icon: nil,
        tooltip: nil, required: false, invalid: false, disabled: false,
        name: nil, value: nil, type: "text", input_class: nil, wrapper_class: nil,
        class: nil, **_opts
      )
        @size = size.to_sym
        @label = label
        @hint = hint
        @placeholder = placeholder
        @icon = icon
        @tooltip = tooltip
        @required = required
        @invalid = invalid
        @disabled = disabled
        @name = name
        @value = value
        @type = type
        @input_class = input_class
        @wrapper_class = wrapper_class
        @extra_classes = binding.local_variable_get(:class)
      end

      def wrapper_classes
        has_trailing = @tooltip || @invalid
        has_leading = @icon.present?
        cx(
          WRAPPER_CLASSES,
          "focus-within:ring-2 focus-within:ring-brand",
          @disabled && "cursor-not-allowed bg-disabled_subtle ring-disabled",
          @invalid && "ring-error_subtle",
          @invalid && "focus-within:ring-2 focus-within:ring-error",
          @wrapper_class
        )
      end

      def input_classes
        has_trailing = @tooltip || @invalid
        has_leading = @icon.present?
        cx(
          INPUT_CLASSES,
          SIZE_STYLES.dig(@size, :root),
          has_trailing && (@size == :sm ? "pr-9" : "pr-9.5"),
          has_leading && (@size == :sm ? "pl-10" : "pl-10.5"),
          @disabled && "cursor-not-allowed text-disabled",
          @input_class
        )
      end

      def icon_leading_classes
        cx("pointer-events-none absolute size-5 text-fg-quaternary", @disabled && "text-fg-disabled", SIZE_STYLES.dig(@size, :icon_leading))
      end

      def icon_trailing_classes
        cx("pointer-events-none absolute size-4 text-fg-error-secondary", SIZE_STYLES.dig(@size, :icon_trailing))
      end
    end
  end
end
