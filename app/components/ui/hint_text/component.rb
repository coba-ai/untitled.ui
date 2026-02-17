# frozen_string_literal: true

module Ui
  module HintText
    class Component < Ui::Base
      # @param invalid [Boolean] whether the field is in an error state
      # @param class [String] additional CSS classes
      def initialize(invalid: false, **attrs)
        super(**attrs)
        @invalid = invalid
        @extra_classes = attrs[:class]
      end

      private

      def root_classes
        cx(
          "text-sm",
          @invalid ? "text-error-primary" : "text-tertiary",
          @extra_classes
        )
      end
    end
  end
end
