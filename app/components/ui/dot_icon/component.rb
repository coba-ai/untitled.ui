# frozen_string_literal: true

module Ui
  module DotIcon
    class Component < Ui::Base
      VARIANTS = {
        size: {
          sm: { wh: 8, c: 4, r: 2.5 },
          md: { wh: 10, c: 5, r: 4 },
          lg: { wh: 12, c: 6, r: 5 }
        }
      }.freeze

      DEFAULTS = { size: :md }.freeze

      # @param size [Symbol] :sm, :md, or :lg
      # @param color [String] CSS color class (applied via text-color utility)
      # @param class [String] additional CSS classes
      def initialize(size: :md, color: nil, **attrs)
        super()
        @size = validate_variant(:size, size)
        @color = color
        @extra_classes = attrs[:class]
      end

      private

      def dimensions
        VARIANTS[:size][@size]
      end

      def root_classes
        cx(@color, @extra_classes)
      end
    end
  end
end
