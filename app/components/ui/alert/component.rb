# frozen_string_literal: true

module Ui
  module Alert
    class Component < Ui::Base
      VARIANT_STYLES = {
        info: {
          root: "bg-utility-brand-50 ring-utility-brand-200",
          icon: "text-utility-brand-500",
          title: "text-utility-brand-700",
          description: "text-utility-brand-700",
          close: "text-utility-brand-500 hover:text-utility-brand-700"
        },
        success: {
          root: "bg-utility-success-50 ring-utility-success-200",
          icon: "text-utility-success-500",
          title: "text-utility-success-700",
          description: "text-utility-success-700",
          close: "text-utility-success-500 hover:text-utility-success-700"
        },
        warning: {
          root: "bg-utility-warning-50 ring-utility-warning-200",
          icon: "text-utility-warning-500",
          title: "text-utility-warning-700",
          description: "text-utility-warning-700",
          close: "text-utility-warning-500 hover:text-utility-warning-700"
        },
        error: {
          root: "bg-utility-error-50 ring-utility-error-200",
          icon: "text-utility-error-500",
          title: "text-utility-error-700",
          description: "text-utility-error-700",
          close: "text-utility-error-500 hover:text-utility-error-700"
        }
      }.freeze

      VARIANT_ICONS = {
        info: '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" ' \
              'stroke="currentColor" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" ' \
              'd="M11.25 11.25l.041-.02a.75.75 0 0 1 1.063.852l-.708 2.836a.75.75 0 0 0 1.063.853l.041-.021M21 ' \
              '12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9-3.75h.008v.008H12V8.25Z"/></svg>',
        success: '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" ' \
                 'stroke="currentColor" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" ' \
                 'd="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>',
        warning: '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" ' \
                 'stroke="currentColor" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" ' \
                 'd="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 ' \
                 '1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z"/></svg>',
        error: '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" ' \
               'stroke="currentColor" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" ' \
               'd="m9.75 9.75 4.5 4.5m0-4.5-4.5 4.5M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>'
      }.freeze

      BASE_CLASSES = "flex items-start gap-3 rounded-lg p-4 ring-1 ring-inset"

      attr_reader :title, :description, :variant, :dismissible, :icon, :extra_classes

      # @param title [String] bold heading text
      # @param description [String] supporting body text
      # @param variant [Symbol] :info, :success, :warning, or :error
      # @param dismissible [Boolean] whether to show a close button
      # @param icon [String, nil] custom SVG icon (auto-selected from variant when nil)
      # @param class [String] additional CSS classes
      def initialize(title: nil, description: nil, variant: :info, dismissible: false, icon: nil, class: nil, **_opts)
        @title = title
        @description = description
        @variant = variant.to_sym
        @dismissible = dismissible
        @icon = icon || VARIANT_ICONS[@variant]
        @extra_classes = binding.local_variable_get(:class)
      end

      def root_classes
        cx(
          BASE_CLASSES,
          VARIANT_STYLES.dig(@variant, :root),
          @extra_classes
        )
      end

      def icon_classes
        cx("size-5 shrink-0 mt-0.5", VARIANT_STYLES.dig(@variant, :icon))
      end

      def title_classes
        cx("text-sm font-semibold", VARIANT_STYLES.dig(@variant, :title))
      end

      def description_classes
        cx("text-sm", VARIANT_STYLES.dig(@variant, :description))
      end

      def close_classes
        cx(
          "flex shrink-0 cursor-pointer items-center justify-center rounded-md p-1",
          "transition duration-100 ease-linear focus:outline-hidden focus-visible:outline-2 outline-focus-ring",
          VARIANT_STYLES.dig(@variant, :close)
        )
      end
    end
  end
end
