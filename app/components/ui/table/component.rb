# frozen_string_literal: true

module Ui
  module Table
    class Component < Ui::Base
      attr_reader :size, :extra_classes

      renders_one :header_content
      renders_many :columns, ->(label:, sortable: false, tooltip: nil, **opts) {
        Ui::Table::Column.new(label: label, sortable: sortable, tooltip: tooltip, size: @size, **opts)
      }

      def initialize(size: :md, class: nil, **_opts)
        @size = size.to_sym
        @extra_classes = binding.local_variable_get(:class)
      end

      def header_height
        @size == :sm ? "h-9" : "h-11"
      end

      def cell_padding
        @size == :sm ? "px-5 py-3" : "px-6 py-4"
      end

      def row_height
        @size == :sm ? "h-14" : "h-18"
      end
    end

    class Column < Ui::Base
      attr_reader :label, :sortable, :tooltip, :size

      def initialize(label:, sortable: false, tooltip: nil, size: :md, **_opts)
        @label = label
        @sortable = sortable
        @tooltip = tooltip
        @size = size
      end
    end
  end
end
