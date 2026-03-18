# frozen_string_literal: true

module Ui
  module Table
    class Component < Ui::Base
      attr_reader :size, :extra_classes, :selectable, :sortable

      renders_one :header_content
      renders_one :bulk_actions
      renders_many :columns, lambda { |label:, sortable: false, tooltip: nil, **opts|
        Ui::Table::Column.new(label: label, sortable: sortable || @sortable, tooltip: tooltip, size: @size, **opts)
      }

      def initialize(size: :md, selectable: false, sortable: false, class: nil, **_opts)
        @size = size.to_sym
        @selectable = selectable
        @sortable = sortable
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

      def stimulus_controller_attrs
        return {} unless @selectable || @sortable

        { "data-controller" => "table" }
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
