# frozen_string_literal: true

module Ui
  module DatePicker
    class Component < Ui::Base
      SIZE_STYLES = {
        sm: { root: "px-3 py-2", icon: "right-3" },
        md: { root: "px-3.5 py-2.5", icon: "right-3.5" }
      }.freeze

      WRAPPER_CLASSES = "relative flex w-full flex-row place-content-center place-items-center rounded-lg bg-primary shadow-xs ring-1 ring-primary transition-shadow duration-100 ease-linear ring-inset"
      DISPLAY_CLASSES = "m-0 w-full cursor-pointer bg-transparent text-md text-primary ring-0 outline-hidden placeholder:text-placeholder"

      attr_reader :name, :value, :placeholder, :label, :hint, :required,
                  :invalid, :disabled, :min, :max, :format, :size, :id, :extra_classes

      def initialize(
        name: nil, value: nil, placeholder: "Select date", label: nil, hint: nil,
        required: false, invalid: false, disabled: false, min: nil, max: nil,
        format: "%Y-%m-%d", size: :sm, id: nil, class: nil, **_opts
      )
        @name = name
        @value = normalize_date(value)
        @placeholder = placeholder
        @label = label
        @hint = hint
        @required = required
        @invalid = invalid
        @disabled = disabled
        @min = normalize_date(min)
        @max = normalize_date(max)
        @format = format
        @size = size.to_sym
        @id = id
        @extra_classes = binding.local_variable_get(:class)
      end

      def wrapper_classes
        cx(
          WRAPPER_CLASSES,
          @disabled && "cursor-not-allowed bg-disabled_subtle ring-disabled",
          @invalid && "ring-error_subtle",
          @invalid && "focus-within:ring-2 focus-within:ring-error",
          !@invalid && "focus-within:ring-2 focus-within:ring-brand"
        )
      end

      def display_classes
        cx(
          DISPLAY_CLASSES,
          SIZE_STYLES.dig(@size, :root),
          "pr-10",
          @disabled && "cursor-not-allowed text-disabled"
        )
      end

      def icon_classes
        cx(
          "pointer-events-none absolute size-5 text-fg-quaternary",
          @disabled && "text-fg-disabled",
          SIZE_STYLES.dig(@size, :icon)
        )
      end

      def display_value
        return nil if @value.blank?

        date = @value.is_a?(Date) ? @value : Date.parse(@value.to_s)
        date.strftime(@format)
      rescue ArgumentError
        @value.to_s
      end

      def hidden_value
        return nil if @value.blank?

        date = @value.is_a?(Date) ? @value : Date.parse(@value.to_s)
        date.strftime("%Y-%m-%d")
      rescue ArgumentError
        @value.to_s
      end

      def stimulus_values
        values = {}
        values[:format] = @format
        values[:min] = @min.to_s if @min.present?
        values[:max] = @max.to_s if @max.present?
        values[:value] = hidden_value if @value.present?
        values
      end

      private

      def normalize_date(val)
        return nil if val.nil?
        return val if val.is_a?(Date)

        val.to_s.presence
      end
    end
  end
end
