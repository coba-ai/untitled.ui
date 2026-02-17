# frozen_string_literal: true

module Ui
  module Badge
    class Component < Ui::Base
      COLOR_STYLES = {
        gray: { root: "bg-utility-gray-50 text-utility-gray-700 ring-utility-gray-200", addon: "text-utility-gray-500" },
        brand: { root: "bg-utility-brand-50 text-utility-brand-700 ring-utility-brand-200", addon: "text-utility-brand-500" },
        error: { root: "bg-utility-error-50 text-utility-error-700 ring-utility-error-200", addon: "text-utility-error-500" },
        warning: { root: "bg-utility-warning-50 text-utility-warning-700 ring-utility-warning-200", addon: "text-utility-warning-500" },
        success: { root: "bg-utility-success-50 text-utility-success-700 ring-utility-success-200", addon: "text-utility-success-500" },
        blue: { root: "bg-utility-blue-50 text-utility-blue-700 ring-utility-blue-200", addon: "text-utility-blue-500" },
        indigo: { root: "bg-utility-indigo-50 text-utility-indigo-700 ring-utility-indigo-200", addon: "text-utility-indigo-500" },
        purple: { root: "bg-utility-purple-50 text-utility-purple-700 ring-utility-purple-200", addon: "text-utility-purple-500" },
        pink: { root: "bg-utility-pink-50 text-utility-pink-700 ring-utility-pink-200", addon: "text-utility-pink-500" },
        orange: { root: "bg-utility-orange-50 text-utility-orange-700 ring-utility-orange-200", addon: "text-utility-orange-500" }
      }.freeze

      TYPE_STYLES = {
        pill_color: "size-max flex items-center whitespace-nowrap rounded-full ring-1 ring-inset",
        badge_color: "size-max flex items-center whitespace-nowrap rounded-md ring-1 ring-inset",
        badge_modern: "size-max flex items-center whitespace-nowrap rounded-md ring-1 ring-inset shadow-xs"
      }.freeze

      PILL_SIZES = {
        sm: "py-0.5 px-2 text-xs font-medium",
        md: "py-0.5 px-2.5 text-sm font-medium",
        lg: "py-1 px-3 text-sm font-medium"
      }.freeze

      BADGE_SIZES = {
        sm: "py-0.5 px-1.5 text-xs font-medium",
        md: "py-0.5 px-2 text-sm font-medium",
        lg: "py-1 px-2.5 text-sm font-medium rounded-lg"
      }.freeze

      attr_reader :type, :size, :color, :dot, :dismissible, :icon_leading, :icon_trailing, :extra_classes

      def initialize(type: :pill_color, size: :md, color: :gray, dot: false, dismissible: false, icon_leading: nil, icon_trailing: nil, class: nil, **_opts)
        @type = type.to_sym
        @size = size.to_sym
        @color = color.to_sym
        @dot = dot
        @dismissible = dismissible
        @icon_leading = icon_leading
        @icon_trailing = icon_trailing
        @extra_classes = binding.local_variable_get(:class)
      end

      def root_classes
        modern = @type == :badge_modern
        cx(
          TYPE_STYLES[@type],
          size_classes,
          modern ? "bg-primary text-secondary ring-primary" : COLOR_STYLES.dig(@color, :root),
          @extra_classes
        )
      end

      def addon_classes
        COLOR_STYLES.dig(@color, :addon)
      end

      private

      def size_classes
        sizes = @type == :pill_color ? PILL_SIZES : BADGE_SIZES
        sizes[@size]
      end
    end
  end
end
