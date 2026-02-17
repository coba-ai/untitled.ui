# frozen_string_literal: true

module Ui
  module FeaturedIcon
    class Component < Ui::Base
      THEME_COLORS = {
        light: {
          brand: "bg-brand-secondary text-featured-icon-light-fg-brand",
          gray: "bg-tertiary text-featured-icon-light-fg-gray",
          error: "bg-error-secondary text-featured-icon-light-fg-error",
          warning: "bg-warning-secondary text-featured-icon-light-fg-warning",
          success: "bg-success-secondary text-featured-icon-light-fg-success"
        },
        dark: {
          brand: "bg-brand-solid",
          gray: "bg-secondary-solid",
          error: "bg-error-solid",
          warning: "bg-warning-solid",
          success: "bg-success-solid"
        },
        modern: {
          brand: "",
          gray: "text-fg-secondary ring-primary",
          error: "",
          warning: "",
          success: ""
        },
        outline: {
          brand: "",
          gray: "",
          error: "",
          warning: "",
          success: ""
        }
      }.freeze

      SIZES = {
        sm: "size-8",
        md: "size-10",
        lg: "size-12",
        xl: "size-14"
      }.freeze

      # @param theme [Symbol] :light, :dark, :modern, or :outline
      # @param color [Symbol] :brand, :gray, :error, :warning, or :success
      # @param size [Symbol] :sm, :md, :lg, or :xl
      # @param icon [String, nil] heroicon name
      # @param class [String] additional CSS classes
      def initialize(theme: :light, color: :brand, size: :sm, icon: nil, **attrs)
        super(**attrs)
        @theme = theme.to_sym
        @color = color.to_sym
        @size = size.to_sym
        @icon = icon
        @extra_classes = attrs[:class]
      end

      private

      def root_classes
        cx(
          "inline-flex items-center justify-center rounded-full",
          SIZES.fetch(@size, SIZES[:sm]),
          color_classes,
          @extra_classes
        )
      end

      def color_classes
        THEME_COLORS.dig(@theme, @color) || ""
      end
    end
  end
end
