# frozen_string_literal: true

module Ui
  module Accordion
    class ItemComponent < Ui::Base
      attr_reader :title, :open, :icon, :extra_classes

      def initialize(title:, open: false, icon: nil, class: nil, **_opts)
        @title = title
        @open = open
        @icon = icon
        @item_id = SecureRandom.hex(4)
        @extra_classes = binding.local_variable_get(:class)
      end

      def item_id
        @item_id
      end

      def header_classes
        cx(
          "flex w-full cursor-pointer items-center justify-between px-6 py-4 text-left",
          "text-sm font-semibold text-secondary transition duration-100 ease-linear",
          "outline-focus-ring hover:text-primary"
        )
      end

      def panel_classes
        cx(
          "overflow-hidden transition-all duration-300 ease-in-out",
          @extra_classes
        )
      end

      def chevron_classes
        cx(
          "size-5 shrink-0 text-fg-quaternary transition-transform duration-300",
          @open && "rotate-180"
        )
      end
    end
  end
end
