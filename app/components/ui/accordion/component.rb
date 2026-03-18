# frozen_string_literal: true

module Ui
  module Accordion
    class Component < Ui::Base
      attr_reader :multiple, :extra_classes

      renders_many :items, Ui::Accordion::ItemComponent

      def initialize(multiple: false, class: nil, **_opts)
        @multiple = multiple
        @extra_classes = binding.local_variable_get(:class)
      end

      def root_classes
        cx(
          "divide-y divide-border-secondary rounded-xl border border-border-secondary bg-primary",
          @extra_classes
        )
      end
    end
  end
end
