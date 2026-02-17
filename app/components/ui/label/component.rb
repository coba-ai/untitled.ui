# frozen_string_literal: true

module Ui
  module Label
    class Component < Ui::Base
      # @param text [String] the label text
      # @param required [Boolean] whether to show a required asterisk
      # @param tooltip [String] optional tooltip text
      # @param class [String] additional CSS classes
      def initialize(text:, required: false, tooltip: nil, **attrs)
        super()
        @text = text
        @required = required
        @tooltip = tooltip
        @extra_classes = attrs[:class]
      end

      private

      attr_reader :text, :tooltip

      def required?
        @required
      end

      def root_classes
        cx("flex cursor-default items-center gap-0.5 text-sm font-medium text-secondary", @extra_classes)
      end
    end
  end
end
