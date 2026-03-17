# frozen_string_literal: true

module Ui
  module Breadcrumb
    class ItemComponent < Ui::Base
      attr_reader :label, :href, :icon

      def initialize(label:, href: nil, icon: nil, current: nil, **_opts)
        @label = label
        @href = href
        @icon = icon
        @current = current
      end

      def current?
        @current.nil? ? @href.nil? : @current
      end
    end
  end
end
