# frozen_string_literal: true

module Ui
  module Drawer
    class Component < Ui::Base
      attr_reader :position, :size, :extra_classes, :drawer_id

      POSITIONS = %i[left right].freeze
      SIZES = %i[sm md lg].freeze

      SIZE_CLASSES = {
        sm: "w-80",
        md: "w-96",
        lg: "w-[32rem]"
      }.freeze

      renders_one :trigger
      renders_one :header
      renders_one :footer

      def initialize(position: :right, size: :md, id: nil, class: nil, **_opts)
        @position = POSITIONS.include?(position) ? position : :right
        @size = SIZES.include?(size) ? size : :md
        @drawer_id = id || "drawer-#{SecureRandom.hex(4)}"
        @extra_classes = binding.local_variable_get(:class)
      end

      def overlay_classes
        cx(
          "hidden open:flex",
          "fixed inset-0 z-50 m-0 h-dvh w-dvw max-h-none max-w-none",
          "bg-overlay/70 backdrop-blur-[6px]",
          "outline-hidden",
          position == :left ? "justify-start" : "justify-end"
        )
      end

      def panel_classes
        cx(
          "flex flex-col h-full bg-primary shadow-xl ring-1 ring-secondary_alt outline-hidden",
          SIZE_CLASSES[@size],
          @extra_classes
        )
      end
    end
  end
end
