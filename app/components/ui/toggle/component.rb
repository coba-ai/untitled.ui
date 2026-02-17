# frozen_string_literal: true

module Ui
  module Toggle
    class Component < Ui::Base
      TRACK_SIZES = { sm: "h-5 w-9 p-0.5", md: "h-6 w-11 p-0.5" }.freeze
      THUMB_SIZES = {
        sm: { base: "size-4", translate: "translate-x-4" },
        md: { base: "size-5", translate: "translate-x-5" }
      }.freeze

      attr_reader :size, :label, :hint, :checked, :disabled, :name, :extra_classes

      def initialize(size: :sm, label: nil, hint: nil, checked: false, disabled: false, name: nil, class: nil, **_opts)
        @size = size.to_sym
        @label = label
        @hint = hint
        @checked = checked
        @disabled = disabled
        @name = name
        @extra_classes = binding.local_variable_get(:class)
      end

      def track_classes
        cx(
          "cursor-pointer rounded-full outline-focus-ring transition duration-150 ease-linear",
          TRACK_SIZES[@size],
          @checked ? "bg-brand-solid" : "bg-tertiary",
          @disabled && "cursor-not-allowed bg-disabled"
        )
      end

      def thumb_classes
        cx(
          "rounded-full bg-fg-white shadow-sm transition-transform duration-150 ease-in-out",
          THUMB_SIZES.dig(@size, :base),
          @checked && THUMB_SIZES.dig(@size, :translate),
          @disabled && "bg-toggle-button-fg_disabled"
        )
      end
    end
  end
end
