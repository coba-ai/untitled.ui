# frozen_string_literal: true

module Ui
  module Navigation
    module List
      class Component < Ui::Base
        # Items follow this hash structure:
        # { label:, href:, icon: (SVG string), badge:, items: [...sub_items], divider: true/false }
        attr_reader :items, :active_url, :extra_classes

        def initialize(items: [], active_url: nil, class: nil, **_opts)
          @items = items
          @active_url = active_url
          @extra_classes = binding.local_variable_get(:class)
        end

        def list_classes
          cx("mt-4 flex flex-col px-2 lg:px-4", @extra_classes)
        end

        def divider?(item)
          item[:divider] == true
        end

        def collapsible?(item)
          item[:items].present?
        end

        def active?(item)
          item[:href] == @active_url
        end

        def child_active?(item)
          item[:items]&.any? { |sub| sub[:href] == @active_url }
        end
      end
    end
  end
end
