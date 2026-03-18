# frozen_string_literal: true

module Ui
  module Skeleton
    class Component < Ui::Base
      VARIANT_STYLES = {
        text: "rounded",
        circular: "rounded-full",
        rectangular: "rounded-lg"
      }.freeze

      attr_reader :variant, :width, :height, :lines, :animated, :extra_classes

      def initialize(variant: :text, width: nil, height: nil, lines: 3, animated: true, class: nil, **_opts)
        @variant = variant.to_sym
        @width = width
        @height = height
        @lines = lines
        @animated = animated
        @extra_classes = binding.local_variable_get(:class)
      end

      def root_classes
        cx(
          "block bg-secondary",
          VARIANT_STYLES[@variant],
          animated ? "animate-pulse" : nil,
          @extra_classes
        )
      end

      def line_classes(index)
        cx(
          "block h-4 bg-secondary rounded",
          animated ? "animate-pulse" : nil,
          line_width(index)
        )
      end

      def line_width(index)
        index == lines - 1 ? "w-3/4" : "w-full"
      end

      def inline_style
        parts = []
        parts << "width: #{width};" if width
        parts << "height: #{height};" if height
        parts.join(" ").presence
      end
    end
  end
end
