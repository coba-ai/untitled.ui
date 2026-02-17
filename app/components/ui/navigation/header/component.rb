# frozen_string_literal: true

module Ui
  module Navigation
    module Header
      class Component < Ui::Base
        attr_reader :active_url, :items, :sub_items, :hide_border, :show_avatar_dropdown, :extra_classes

        renders_one :logo
        renders_one :trailing_content
        renders_one :avatar
        renders_one :account_menu
        renders_one :mobile_sidebar

        def initialize(items: [], active_url: nil, sub_items: nil, hide_border: false, show_avatar_dropdown: true, class: nil, **_opts)
          @items = items
          @active_url = active_url
          @sub_items = sub_items
          @hide_border = hide_border
          @show_avatar_dropdown = show_avatar_dropdown
          @extra_classes = binding.local_variable_get(:class)
        end

        def active_sub_items
          @sub_items || active_item_sub_items
        end

        def show_secondary_nav?
          active_sub_items&.any?
        end

        def header_classes
          cx(
            "flex h-16 w-full items-center justify-center bg-primary md:h-18",
            (!@hide_border || show_secondary_nav?) && "border-b border-secondary",
            @extra_classes
          )
        end

        def secondary_nav_classes
          cx(
            "flex h-16 w-full items-center justify-center bg-primary",
            !@hide_border && "border-b border-secondary"
          )
        end

        private

        def active_item_sub_items
          active = @items.find { |item| item[:href] == @active_url && item[:items]&.any? }
          active&.dig(:items)
        end
      end
    end
  end
end
