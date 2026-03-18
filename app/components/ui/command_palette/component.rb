# frozen_string_literal: true

module Ui
  module CommandPalette
    class Component < Ui::Base
      renders_one :trigger

      attr_reader :placeholder, :items, :extra_classes, :palette_id

      # @param placeholder [String] placeholder text for the search input
      # @param items [Array<Hash>] array of items with :label, :value, :group, :icon keys
      # @param id [String] optional id for the dialog element
      # @param class [String] optional extra CSS classes
      def initialize(placeholder: "Type a command or search...", items: [], id: nil, class: nil, **_opts)
        @placeholder = placeholder
        @items = items
        @palette_id = id || "command-palette-#{SecureRandom.hex(4)}"
        @extra_classes = binding.local_variable_get(:class)
      end

      def grouped_items
        @grouped_items ||= items.group_by { |item| item[:group] || item["group"] }
      end

      def overlay_classes
        cx(
          "hidden open:flex flex-col items-center justify-start pt-[15vh]",
          "fixed inset-0 z-50 m-0 h-dvh w-dvw max-h-none max-w-none",
          "overflow-y-auto bg-overlay/70 backdrop-blur-[6px]",
          "p-4 outline-hidden"
        )
      end

      def dialog_classes
        cx(
          "w-full max-w-xl rounded-xl bg-primary shadow-xl ring-1 ring-secondary_alt outline-hidden",
          @extra_classes
        )
      end

      def items_as_json
        items.to_json
      end
    end
  end
end
