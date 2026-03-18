# frozen_string_literal: true

module Ui
  module Timeline
    class Component < Ui::Base
      attr_reader :extra_classes

      renders_many :items, Ui::Timeline::ItemComponent

      # @param class [String] additional CSS classes for the root element
      def initialize(class: nil, **_opts)
        @extra_classes = binding.local_variable_get(:class)
      end

      def root_classes
        cx("flow-root", @extra_classes)
      end

      # Mark the last item so it skips rendering the connector line
      def prepared_items
        list = items
        list.each_with_index do |item, i|
          item.last! if i == list.size - 1
        end
        list
      end
    end
  end
end
