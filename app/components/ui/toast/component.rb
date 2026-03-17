# frozen_string_literal: true

module Ui
  module Toast
    class Component < Ui::Base
      VARIANT_STYLES = {
        success: {
          root: "bg-primary ring-1 ring-inset ring-primary",
          icon: "text-utility-success-600"
        },
        error: {
          root: "bg-primary ring-1 ring-inset ring-primary",
          icon: "text-utility-error-600"
        },
        warning: {
          root: "bg-primary ring-1 ring-inset ring-primary",
          icon: "text-utility-warning-600"
        },
        info: {
          root: "bg-primary ring-1 ring-inset ring-primary",
          icon: "text-utility-brand-600"
        }
      }.freeze

      SIZE_STYLES = {
        sm: { root: "p-3 gap-3", title: "text-sm", description: "text-xs" },
        md: { root: "p-4 gap-4", title: "text-sm", description: "text-sm" }
      }.freeze

      ICON_PATHS = {
        success: "M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z",
        error: "M12 9v3.75m9-.75a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 3.75h.008v.008H12v-.008Z",
        warning: "M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z",
        info: "m11.25 11.25.041-.02a.75.75 0 0 1 1.063.852l-.708 2.836a.75.75 0 0 0 1.063.853l.041-.021M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9-3.75h.008v.008H12V8.25Z"
      }.freeze

      attr_reader :title, :description, :variant, :size, :dismissible, :auto_dismiss, :duration, :icon, :extra_classes

      # @param title [String] toast heading text
      # @param description [String, nil] optional description text
      # @param variant [Symbol] :success, :error, :warning, or :info
      # @param size [Symbol] :sm or :md
      # @param dismissible [Boolean] show close button (default true)
      # @param auto_dismiss [Boolean] auto-dismiss after duration (default true)
      # @param duration [Integer] auto-dismiss duration in ms (default 5000)
      # @param icon [String, nil] custom icon SVG path, or nil for default variant icon
      # @param class [String] additional CSS classes
      def initialize(title:, description: nil, variant: :info, size: :md, dismissible: true, auto_dismiss: true, duration: 5000, icon: nil, class: nil, **_opts)
        @title = title
        @description = description
        @variant = variant.to_sym
        @size = size.to_sym
        @dismissible = dismissible
        @auto_dismiss = auto_dismiss
        @duration = duration
        @icon = icon
        @extra_classes = binding.local_variable_get(:class)
      end

      def root_classes
        cx(
          "pointer-events-auto w-full max-w-sm overflow-hidden rounded-xl shadow-lg",
          VARIANT_STYLES.dig(@variant, :root),
          SIZE_STYLES.dig(@size, :root),
          @extra_classes
        )
      end

      def icon_classes
        cx(
          "size-5 shrink-0",
          VARIANT_STYLES.dig(@variant, :icon)
        )
      end

      def title_classes
        cx(
          "font-semibold text-primary",
          SIZE_STYLES.dig(@size, :title)
        )
      end

      def description_classes
        cx(
          "text-tertiary mt-1",
          SIZE_STYLES.dig(@size, :description)
        )
      end

      def icon_path
        @icon || ICON_PATHS[@variant]
      end

      def stimulus_values
        values = {}
        values["toast-auto-dismiss-value"] = @auto_dismiss.to_s
        values["toast-duration-value"] = @duration.to_s
        values
      end
    end
  end
end
