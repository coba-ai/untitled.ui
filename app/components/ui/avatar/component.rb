# frozen_string_literal: true

module Ui
  module Avatar
    class Component < Ui::Base
      SIZE_STYLES = {
        xxs: { root: "size-4 outline-[0.5px] -outline-offset-[0.5px]", initials: "text-xs font-semibold", icon: "size-3" },
        xs: { root: "size-6 outline-[0.5px] -outline-offset-[0.5px]", initials: "text-xs font-semibold", icon: "size-4" },
        sm: { root: "size-8 outline-[0.75px] -outline-offset-[0.75px]", initials: "text-sm font-semibold", icon: "size-5" },
        md: { root: "size-10 outline-1 -outline-offset-1", initials: "text-md font-semibold", icon: "size-6" },
        lg: { root: "size-12 outline-1 -outline-offset-1", initials: "text-lg font-semibold", icon: "size-7" },
        xl: { root: "size-14 outline-1 -outline-offset-1", initials: "text-xl font-semibold", icon: "size-8" },
        "2xl": { root: "size-16 outline-1 -outline-offset-1", initials: "text-display-xs font-semibold", icon: "size-8" }
      }.freeze

      STATUS_STYLES = {
        online: "bg-success-500",
        offline: "bg-gray-300"
      }.freeze

      STATUS_SIZES = {
        xxs: "size-1.5", xs: "size-2", sm: "size-2.5", md: "size-3",
        lg: "size-3.5", xl: "size-4", "2xl": "size-4.5"
      }.freeze

      attr_reader :size, :src, :alt, :initials, :status, :extra_classes

      def initialize(size: :md, src: nil, alt: nil, initials: nil, status: nil, class: nil, **_opts)
        @size = size.to_sym
        @src = src
        @alt = alt
        @initials = initials
        @status = status&.to_sym
        @extra_classes = binding.local_variable_get(:class)
      end

      def root_classes
        cx(
          "relative inline-flex shrink-0 items-center justify-center rounded-full bg-avatar-bg outline outline-avatar-contrast-border",
          SIZE_STYLES.dig(@size, :root),
          @extra_classes
        )
      end

      def status_classes
        cx(
          "absolute right-0 bottom-0 rounded-full ring-2 ring-white",
          STATUS_SIZES[@size],
          STATUS_STYLES[@status]
        )
      end
    end
  end
end
