# frozen_string_literal: true

module Ui
  module Tabs
    class Component < Ui::Base
      TAB_TYPES = {
        button_brand: {
          list: "gap-1",
          base: "outline-focus-ring",
          active: "bg-brand-primary_alt text-brand-secondary",
          hover: "hover:bg-brand-primary_alt hover:text-brand-secondary"
        },
        button_gray: {
          list: "gap-1",
          base: "outline-focus-ring",
          active: "bg-active text-secondary",
          hover: "hover:bg-primary_hover hover:text-secondary"
        },
        underline: {
          list: "gap-3 relative before:absolute before:inset-x-0 before:bottom-0 before:h-px before:bg-border-secondary",
          base: "rounded-none border-b-2 border-transparent outline-focus-ring",
          active: "border-fg-brand-primary_alt text-brand-secondary",
          hover: "hover:border-fg-brand-primary_alt hover:text-brand-secondary"
        }
      }.freeze

      SIZE_STYLES = {
        sm: "text-sm font-semibold py-2 px-3",
        md: "text-md font-semibold py-2.5 px-3"
      }.freeze

      attr_reader :type, :size, :full_width, :extra_classes

      renders_many :tabs, ->(id:, label:, badge: nil, active: false, **opts) {
        Ui::Tabs::TabItem.new(id: id, label: label, badge: badge, active: active, type: @type, size: @size, **opts)
      }

      renders_many :panels

      def initialize(type: :button_brand, size: :sm, full_width: false, class: nil, **_opts)
        @type = type.to_sym
        @size = size.to_sym
        @full_width = full_width
        @extra_classes = binding.local_variable_get(:class)
      end

      def list_classes
        cx(
          "flex",
          TAB_TYPES.dig(@type, :list),
          @extra_classes
        )
      end
    end

    class TabItem < Ui::Base
      attr_reader :id, :label, :badge, :active, :type, :size

      def initialize(id:, label:, badge: nil, active: false, type: :button_brand, size: :sm, **_opts)
        @id = id
        @label = label
        @badge = badge
        @active = active
        @type = type.to_sym
        @size = size.to_sym
      end

      def tab_classes
        type_config = Ui::Tabs::Component::TAB_TYPES[@type]
        cx(
          "z-10 flex h-max cursor-pointer items-center justify-center gap-2 rounded-md whitespace-nowrap text-quaternary transition duration-100 ease-linear",
          Ui::Tabs::Component::SIZE_STYLES[@size],
          type_config[:base],
          @active ? type_config[:active] : type_config[:hover]
        )
      end
    end
  end
end
