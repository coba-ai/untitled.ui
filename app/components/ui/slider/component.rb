# frozen_string_literal: true

module Ui
  module Slider
    class Component < Ui::Base
      attr_reader :name, :value, :min, :max, :step, :label, :show_value,
                  :disabled, :id, :extra_classes

      def initialize(
        name: nil,
        value: 50,
        min: 0,
        max: 100,
        step: 1,
        label: nil,
        show_value: true,
        disabled: false,
        id: nil,
        class: nil,
        **_opts
      )
        @name = name
        @value = value
        @min = min
        @max = max
        @step = step
        @label = label
        @show_value = show_value
        @disabled = disabled
        @id = id
        @extra_classes = binding.local_variable_get(:class)
      end

      def percentage
        range = @max - @min
        return 0 if range.zero?

        ((@value - @min).to_f / range * 100).clamp(0, 100)
      end

      def wrapper_classes
        cx("flex w-full flex-col gap-1.5", @extra_classes)
      end

      def track_classes
        cx(
          "relative h-2 w-full rounded-full bg-quaternary",
          @disabled && "cursor-not-allowed opacity-50"
        )
      end

      def range_input_classes
        cx(
          "slider-input absolute inset-0 h-full w-full cursor-pointer appearance-none bg-transparent",
          @disabled && "cursor-not-allowed"
        )
      end
    end
  end
end
