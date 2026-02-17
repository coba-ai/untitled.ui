# frozen_string_literal: true

module Ui
  module CloseButton
    class Component < Ui::Base
      SIZE_STYLES = {
        xs: { root: "size-7", icon: "size-4" },
        sm: { root: "size-9", icon: "size-5" },
        md: { root: "size-10", icon: "size-5" },
        lg: { root: "size-11", icon: "size-6" }
      }.freeze

      THEME_STYLES = {
        light: "text-fg-quaternary hover:bg-primary_hover hover:text-fg-quaternary_hover " \
               "focus-visible:outline-2 focus-visible:outline-offset-2 outline-focus-ring",
        dark: "text-fg-white/70 hover:text-fg-white hover:bg-white/20 " \
              "focus-visible:outline-2 focus-visible:outline-offset-2 outline-focus-ring"
      }.freeze

      BASE_CLASSES = "flex cursor-pointer items-center justify-center rounded-lg p-2 " \
                     "transition duration-100 ease-linear focus:outline-hidden"

      # @param size [Symbol] :xs, :sm, :md, or :lg
      # @param theme [Symbol] :light or :dark
      # @param label [String] accessible label for the button
      # @param class [String] additional CSS classes
      def initialize(size: :sm, theme: :light, label: "Close", **attrs)
        super(**attrs)
        @size = size.to_sym
        @theme = theme.to_sym
        @label = label
        @extra_classes = attrs[:class]
      end

      private

      def size_config
        SIZE_STYLES.fetch(@size, SIZE_STYLES[:sm])
      end

      def root_classes
        cx(
          BASE_CLASSES,
          size_config[:root],
          THEME_STYLES.fetch(@theme, THEME_STYLES[:light]),
          @extra_classes
        )
      end

      def icon_classes
        size_config[:icon]
      end
    end
  end
end
