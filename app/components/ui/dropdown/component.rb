# frozen_string_literal: true

module Ui
  module Dropdown
    class Component < Ui::Base
      attr_reader :extra_classes

      renders_one :trigger
      renders_many :items, ->(label:, icon: nil, addon: nil, disabled: false, href: nil, **opts) {
        Ui::Dropdown::Item.new(label: label, icon: icon, addon: addon, disabled: disabled, href: href, **opts)
      }
      renders_many :separators

      def initialize(class: nil, **_opts)
        @extra_classes = binding.local_variable_get(:class)
      end

      def popover_classes
        cx(
          "w-62 overflow-auto rounded-lg bg-primary shadow-lg ring-1 ring-secondary_alt",
          @extra_classes
        )
      end
    end

    class Item < Ui::Base
      attr_reader :label, :icon, :addon, :disabled, :href

      def initialize(label:, icon: nil, addon: nil, disabled: false, href: nil, **_opts)
        @label = label
        @icon = icon
        @addon = addon
        @disabled = disabled
        @href = href
      end

      def item_classes
        cx(
          "group block cursor-pointer px-1.5 py-px outline-hidden",
          @disabled && "cursor-not-allowed"
        )
      end

      def inner_classes
        cx(
          "relative flex items-center rounded-md px-2.5 py-2 outline-focus-ring transition duration-100 ease-linear",
          !@disabled && "group-hover:bg-primary_hover"
        )
      end

      def label_classes
        cx(
          "grow truncate text-sm font-semibold",
          @disabled ? "text-disabled" : "text-secondary"
        )
      end

      def icon_classes
        cx(
          "mr-2 size-4 shrink-0 stroke-[2.25px]",
          @disabled ? "text-fg-disabled" : "text-fg-quaternary"
        )
      end
    end
  end
end
