# frozen_string_literal: true

module Ui
  module Checkbox
    class Component < Ui::Base
      SIZE_STYLES = {
        sm: { box: "size-4", check: "size-3", label: "text-sm font-medium", hint: "text-sm", gap: "gap-2" },
        md: { box: "size-5 rounded-md", check: "size-3.5", label: "text-md font-medium", hint: "text-md", gap: "gap-3" }
      }.freeze

      attr_reader :size, :label, :hint, :checked, :disabled, :name, :value, :indeterminate, :extra_classes

      def initialize(size: :sm, label: nil, hint: nil, checked: false, disabled: false, name: nil, value: nil, indeterminate: false, class: nil, **_opts)
        @size = size.to_sym
        @label = label
        @hint = hint
        @checked = checked
        @disabled = disabled
        @name = name
        @value = value
        @indeterminate = indeterminate
        @extra_classes = binding.local_variable_get(:class)
      end

      def box_classes
        cx(
          "relative flex shrink-0 cursor-pointer appearance-none items-center justify-center rounded bg-primary ring-1 ring-primary ring-inset",
          SIZE_STYLES.dig(@size, :box),
          (@checked || @indeterminate) && "bg-brand-solid ring-bg-brand-solid",
          @disabled && "cursor-not-allowed bg-disabled_subtle ring-disabled",
          (@label || @hint) && "mt-0.5"
        )
      end

      def check_classes
        cx(
          "pointer-events-none absolute text-fg-white opacity-0 transition-inherit-all",
          SIZE_STYLES.dig(@size, :check),
          @checked && !@indeterminate && "opacity-100",
          @disabled && "text-fg-disabled_subtle"
        )
      end

      def indeterminate_classes
        cx(
          "pointer-events-none absolute text-fg-white opacity-0 transition-inherit-all",
          SIZE_STYLES.dig(@size, :check),
          @indeterminate && "opacity-100",
          @disabled && "text-fg-disabled_subtle"
        )
      end
    end
  end
end
