# frozen_string_literal: true

module Ui
  module LoadingIndicator
    class Component < Ui::Base
      SIZE_STYLES = {
        sm: { root: "gap-4", label: "text-sm font-medium", spinner: "size-8" },
        md: { root: "gap-4", label: "text-sm font-medium", spinner: "size-12" },
        lg: { root: "gap-4", label: "text-lg font-medium", spinner: "size-14" },
        xl: { root: "gap-5", label: "text-lg font-medium", spinner: "size-16" }
      }.freeze

      attr_reader :type, :size, :label

      def initialize(type: :line_simple, size: :sm, label: nil, **_opts)
        @type = type.to_sym
        @size = size.to_sym
        @label = label
      end

      def spinner_classes
        cx("animate-spin", SIZE_STYLES.dig(@size, :spinner))
      end
    end
  end
end
