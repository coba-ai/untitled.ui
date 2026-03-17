# frozen_string_literal: true

module Ui
  module Breadcrumb
    class Component < Ui::Base
      SEPARATORS = {
        chevron: '<svg class="size-4 shrink-0 text-quaternary" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" /></svg>',
        slash: '<svg class="size-4 shrink-0 text-quaternary" viewBox="0 0 16 20" fill="none"><path d="M5.5 18.5L10.5 1.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>'
      }.freeze

      HOME_ICON = '<svg class="size-5 shrink-0" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m2.25 12 8.954-8.955a1.126 1.126 0 0 1 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25" /></svg>'

      attr_reader :separator, :extra_classes

      renders_many :items, Ui::Breadcrumb::ItemComponent

      def initialize(separator: :chevron, class: nil, **_opts)
        @separator = separator.to_sym
        @extra_classes = binding.local_variable_get(:class)
      end

      def root_classes
        cx("flex items-center", @extra_classes)
      end

      def separator_html
        SEPARATORS[@separator]
      end

      def item_classes(item)
        if item.current?
          cx("text-sm font-semibold text-brand-secondary")
        else
          cx("text-sm font-medium text-tertiary hover:text-secondary transition-colors")
        end
      end

      def link_classes
        cx("flex items-center gap-1.5 text-sm font-medium text-tertiary hover:text-secondary transition-colors")
      end
    end
  end
end
