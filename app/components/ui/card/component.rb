# frozen_string_literal: true

module Ui
  module Card
    class Component < Ui::Base
      attr_reader :padding, :shadow, :border, :rounded, :extra_classes

      renders_one :header
      renders_one :footer
      renders_one :media

      PADDING = {
        sm: "p-4",
        md: "p-6",
        lg: "p-8"
      }.freeze

      SHADOW = {
        none: "",
        sm: "shadow-xs",
        md: "shadow-md",
        lg: "shadow-lg"
      }.freeze

      def initialize(padding: :md, shadow: :sm, border: true, rounded: true, class: nil, **_opts)
        @padding = padding.to_sym
        @shadow = shadow.to_sym
        @border = border
        @rounded = rounded
        @extra_classes = binding.local_variable_get(:class)
      end

      def container_classes
        cx(
          "bg-primary overflow-hidden",
          SHADOW[@shadow],
          @border && "ring-1 ring-secondary",
          @rounded && "rounded-xl",
          @extra_classes
        )
      end

      def body_classes
        PADDING[@padding]
      end

      def header_classes
        cx(
          "border-b border-secondary",
          PADDING[@padding]
        )
      end

      def footer_classes
        cx(
          "border-t border-secondary",
          PADDING[@padding]
        )
      end
    end
  end
end
