# frozen_string_literal: true

module Ui
  module Button
    # A versatile button component ported from Untitled UI.
    # Supports multiple sizes, colors, icons, loading state, and polymorphic rendering (button/a).
    #
    # @param size [Symbol] :sm, :md, :lg, :xl (default: :sm)
    # @param color [Symbol] :primary, :secondary, :tertiary, :link_gray, :link_color,
    #   :primary_destructive, :secondary_destructive, :tertiary_destructive, :link_destructive
    # @param tag [Symbol] :button, :a (auto-detected from href)
    # @param href [String] URL for link buttons
    # @param disabled [Boolean] disables the button
    # @param loading [Boolean] shows loading spinner
    # @param icon_leading [String] SVG content for leading icon
    # @param icon_trailing [String] SVG content for trailing icon
    # @param type [String] button type attribute (default: "button")
    class Component < Ui::Base
      COMMON_CLASSES = [
        "group relative inline-flex h-max cursor-pointer items-center justify-center",
        "whitespace-nowrap outline-brand transition duration-100 ease-linear",
        "focus-visible:outline-2 focus-visible:outline-offset-2",
        "disabled:cursor-not-allowed disabled:text-fg-disabled"
      ].join(" ").freeze

      SIZE_STYLES = {
        sm: { root: "gap-1 rounded-lg px-3 py-2 text-sm font-semibold", icon_only: "p-2" },
        md: { root: "gap-1 rounded-lg px-3.5 py-2.5 text-sm font-semibold", icon_only: "p-2.5" },
        lg: { root: "gap-1.5 rounded-lg px-4 py-2.5 text-md font-semibold", icon_only: "p-3" },
        xl: { root: "gap-1.5 rounded-lg px-4.5 py-3 text-md font-semibold", icon_only: "p-3.5" }
      }.freeze

      COLOR_STYLES = {
        primary: "bg-brand-solid text-white shadow-xs-skeumorphic ring-1 ring-transparent ring-inset hover:bg-brand-solid_hover disabled:bg-disabled disabled:shadow-xs disabled:ring-disabled_subtle",
        secondary: "bg-primary text-secondary shadow-xs-skeumorphic ring-1 ring-primary ring-inset hover:bg-primary_hover hover:text-secondary_hover disabled:shadow-xs disabled:ring-disabled_subtle",
        tertiary: "text-tertiary hover:bg-primary_hover hover:text-tertiary_hover",
        link_gray: "justify-normal rounded p-0! text-tertiary hover:text-tertiary_hover",
        link_color: "justify-normal rounded p-0! text-brand-secondary hover:text-brand-secondary_hover",
        primary_destructive: "bg-error-solid text-white shadow-xs-skeumorphic ring-1 ring-transparent outline-error ring-inset hover:bg-error-solid_hover disabled:bg-disabled disabled:shadow-xs disabled:ring-disabled_subtle",
        secondary_destructive: "bg-primary text-error-primary shadow-xs-skeumorphic ring-1 ring-error_subtle outline-error ring-inset hover:bg-error-primary hover:text-error-primary_hover disabled:bg-primary disabled:shadow-xs disabled:ring-disabled_subtle",
        tertiary_destructive: "text-error-primary outline-error hover:bg-error-primary hover:text-error-primary_hover",
        link_destructive: "justify-normal rounded p-0! text-error-primary outline-error hover:text-error-primary_hover"
      }.freeze

      ICON_CLASSES = "pointer-events-none size-5 shrink-0".freeze

      renders_one :icon_leading_slot
      renders_one :icon_trailing_slot

      attr_reader :size, :color, :tag, :href, :disabled, :loading, :type, :extra_classes, :html_options

      def initialize(
        size: :sm,
        color: :primary,
        tag: nil,
        href: nil,
        disabled: false,
        loading: false,
        icon_leading: nil,
        icon_trailing: nil,
        type: "button",
        class: nil,
        **html_options
      )
        @size = size.to_sym
        @color = color.to_sym
        @tag = tag || (href ? :a : :button)
        @href = href
        @disabled = disabled
        @loading = loading
        @icon_leading = icon_leading
        @icon_trailing = icon_trailing
        @type = type
        @extra_classes = binding.local_variable_get(:class)
        @html_options = html_options
      end

      def icon_only?
        (@icon_leading || icon_leading_slot) && !content?
      end

      def link_type?
        %i[link_gray link_color link_destructive].include?(@color)
      end

      def root_classes
        cx(
          COMMON_CLASSES,
          SIZE_STYLES.dig(@size, :root),
          icon_only? && SIZE_STYLES.dig(@size, :icon_only),
          COLOR_STYLES[@color],
          @loading && "pointer-events-none",
          @extra_classes
        )
      end

      def root_tag
        @tag
      end

      def root_attrs
        attrs = @html_options.merge(class: root_classes)

        if root_tag == :a
          attrs[:href] = @disabled ? nil : @href
          attrs[:role] = "button" if @disabled
          attrs[:"aria-disabled"] = true if @disabled
        else
          attrs[:type] = @type
          attrs[:disabled] = true if @disabled
        end

        attrs[:"data-loading"] = true if @loading
        attrs
      end

      def has_leading_icon?
        @icon_leading.present? || icon_leading_slot.present?
      end

      def has_trailing_icon?
        @icon_trailing.present? || icon_trailing_slot.present?
      end

      def icon_leading_content
        icon_leading_slot || @icon_leading&.html_safe
      end

      def icon_trailing_content
        icon_trailing_slot || @icon_trailing&.html_safe
      end
    end
  end
end
