# frozen_string_literal: true

module Ui
  module Timeline
    class ItemComponent < Ui::Base
      COLORS = %i[gray brand success error warning].freeze

      COLOR_DOT_CLASSES = {
        gray: "bg-fg-quaternary",
        brand: "bg-brand-solid",
        success: "bg-utility-success-500",
        error: "bg-utility-error-500",
        warning: "bg-utility-warning-500"
      }.freeze

      COLOR_ICON_CLASSES = {
        gray: "bg-secondary text-fg-secondary ring-border-secondary",
        brand: "bg-brand-solid text-white ring-brand-solid",
        success: "bg-utility-success-50 text-utility-success-700 ring-utility-success-200",
        error: "bg-utility-error-50 text-utility-error-700 ring-utility-error-200",
        warning: "bg-utility-warning-50 text-utility-warning-700 ring-utility-warning-200"
      }.freeze

      attr_reader :title, :description, :timestamp, :icon, :color, :last

      # @param title [String] the event title
      # @param description [String, nil] optional supporting text
      # @param timestamp [String, nil] optional time label
      # @param icon [String, nil] optional SVG icon string; renders a dot when nil
      # @param color [Symbol] :gray, :brand, :success, :error, or :warning
      def initialize(title:, description: nil, timestamp: nil, icon: nil, color: :gray, **_opts)
        @title = title
        @description = description
        @timestamp = timestamp
        @icon = icon
        @color = color.to_sym
        @last = false
      end

      # Called by the parent component to mark the final item
      def last!
        @last = true
        self
      end

      def dot_classes
        cx("size-2.5 rounded-full ring-2 ring-primary", COLOR_DOT_CLASSES[@color])
      end

      def icon_wrapper_classes
        cx(
          "flex size-8 shrink-0 items-center justify-center rounded-full ring-1",
          COLOR_ICON_CLASSES[@color]
        )
      end

      def icon_classes
        cx("size-4 shrink-0")
      end

      def connector_classes
        cx("absolute left-[calc(50%-0.5px)] top-full h-full w-px bg-border-secondary")
      end
    end
  end
end
