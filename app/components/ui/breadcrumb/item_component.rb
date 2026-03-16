# frozen_string_literal: true

module Ui
  module Breadcrumb
    class ItemComponent < Ui::Base
      attr_reader :label, :href, :icon

      def initialize(label:, href: nil, icon: nil, **_opts)
        @label = label
        @href = href
        @icon = icon
      end

      def current?
        @href.nil?
      end
    end
  end
end
