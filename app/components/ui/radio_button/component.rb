# frozen_string_literal: true

module Ui
  module RadioButton
    class Component < Ui::Base
      SIZE_STYLES = {
        sm: { radio: "size-4 min-h-4 min-w-4", dot: "size-1.5", label: "text-sm font-medium", hint: "text-sm", gap: "gap-2" },
        md: { radio: "size-5 min-h-5 min-w-5", dot: "size-2", label: "text-md font-medium", hint: "text-md", gap: "gap-3" }
      }.freeze

      attr_reader :size, :label, :hint, :checked, :disabled, :name, :value, :extra_classes

      def initialize(size: :sm, label: nil, hint: nil, checked: false, disabled: false, name: nil, value: nil, class: nil, **_opts)
        @size = size.to_sym
        @label = label
        @hint = hint
        @checked = checked
        @disabled = disabled
        @name = name
        @value = value
        @extra_classes = binding.local_variable_get(:class)
      end

      def radio_classes
        cx(
          "flex cursor-pointer appearance-none items-center justify-center rounded-full ring-1 ring-inset transition-inherit-all",
          "bg-primary ring-primary peer-checked:bg-brand-solid peer-checked:ring-bg-brand-solid",
          SIZE_STYLES.dig(@size, :radio),
          @disabled && "cursor-not-allowed border-disabled bg-disabled_subtle",
          (@label || @hint) && "mt-0.5"
        )
      end

      def dot_classes
        cx(
          "rounded-full bg-fg-white opacity-0 peer-checked:opacity-100 transition-inherit-all",
          SIZE_STYLES.dig(@size, :dot),
          @disabled && "bg-fg-disabled_subtle"
        )
      end
    end
  end
end
