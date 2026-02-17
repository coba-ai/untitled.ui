# frozen_string_literal: true

module Ui
  module ButtonGroup
    class Component < Ui::Base
      attr_reader :extra_classes

      def initialize(class: nil, **_opts)
        @extra_classes = binding.local_variable_get(:class)
      end

      def root_classes
        cx(
          "inline-flex items-center rounded-lg shadow-xs-skeumorphic ring-1 ring-primary ring-inset",
          "[&>*]:rounded-none [&>*]:shadow-none [&>*]:ring-0",
          "[&>*:first-child]:rounded-l-lg [&>*:last-child]:rounded-r-lg",
          "[&>*:not(:first-child)]:-ml-px",
          @extra_classes
        )
      end
    end
  end
end
