# frozen_string_literal: true

module Ui
  module Tooltip
    class Component < Ui::Base
      attr_reader :title, :description, :placement, :extra_classes

      renders_one :trigger

      def initialize(title:, description: nil, placement: :top, class: nil, **_opts)
        @title = title
        @description = description
        @placement = placement.to_sym
        @extra_classes = binding.local_variable_get(:class)
      end

      def tooltip_classes
        cx(
          "z-50 flex max-w-xs origin-center flex-col items-start gap-1 rounded-lg bg-primary-solid px-3 shadow-lg",
          @description ? "py-3" : "py-2",
          @extra_classes
        )
      end

      def placement_data
        case @placement
        when :top then "top"
        when :bottom then "bottom"
        when :left then "left"
        when :right then "right"
        else "top"
        end
      end
    end
  end
end
