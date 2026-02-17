# frozen_string_literal: true

module Ui
  module EmptyState
    class Component < Ui::Base
      attr_reader :size, :title, :description, :extra_classes

      renders_one :icon
      renders_one :actions

      def initialize(size: :lg, title: nil, description: nil, class: nil, **_opts)
        @size = size.to_sym
        @title = title
        @description = description
        @extra_classes = binding.local_variable_get(:class)
      end

      def title_classes
        cx(
          "text-md font-semibold text-primary",
          @size == :md && "text-lg font-semibold",
          @size == :lg && "text-xl font-semibold"
        )
      end

      def description_classes
        cx("text-center text-sm text-tertiary", @size == :lg && "text-md")
      end

      def content_gap
        @size == :sm ? "mb-6 gap-1" : "mb-8 gap-2"
      end

      def header_margin
        @size == :sm ? "mb-4" : "mb-5"
      end
    end
  end
end
