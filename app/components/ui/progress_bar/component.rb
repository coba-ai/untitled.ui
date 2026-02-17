# frozen_string_literal: true

module Ui
  module ProgressBar
    class Component < Ui::Base
      attr_reader :value, :min, :max, :label_position, :extra_classes, :progress_class

      def initialize(value: 0, min: 0, max: 100, label_position: nil, progress_class: nil, class: nil, **_opts)
        @value = value
        @min = min
        @max = max
        @label_position = label_position&.to_sym
        @progress_class = progress_class
        @extra_classes = binding.local_variable_get(:class)
      end

      def percentage
        ((@value - @min).to_f * 100 / (@max - @min)).clamp(0, 100)
      end

      def formatted_value
        "#{percentage.round}%"
      end

      def bar_classes
        cx("h-2 w-full overflow-hidden rounded-md bg-quaternary", @extra_classes)
      end

      def fill_classes
        cx("size-full rounded-md bg-fg-brand-primary transition duration-75 ease-linear", @progress_class)
      end

      def fill_style
        "transform: translateX(-#{100 - percentage}%)"
      end
    end
  end
end
