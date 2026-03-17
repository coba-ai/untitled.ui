# frozen_string_literal: true

module Ui
  module Stat
    class Component < Ui::Base
      TREND_STYLES = {
        up: { color: "text-utility-success-700", icon_rotation: "" },
        down: { color: "text-utility-error-700", icon_rotation: "rotate-180" },
        neutral: { color: "text-tertiary", icon_rotation: "hidden" }
      }.freeze

      attr_reader :label, :value, :change, :trend, :period, :icon, :extra_classes

      def initialize(label:, value:, change: nil, trend: nil, period: nil, icon: nil, class: nil, **_opts)
        @label = label
        @value = value
        @change = change
        @trend = trend&.to_sym || detect_trend
        @period = period
        @icon = icon
        @extra_classes = binding.local_variable_get(:class)
      end

      def root_classes
        cx("rounded-xl border border-primary bg-primary p-6 shadow-xs", @extra_classes)
      end

      def trend_color
        TREND_STYLES.dig(@trend, :color)
      end

      def trend_icon_rotation
        TREND_STYLES.dig(@trend, :icon_rotation)
      end

      def show_trend?
        @change.present?
      end

      private

      def detect_trend
        return :neutral if @change.blank?

        change_str = @change.to_s.strip
        if change_str.start_with?("+") || (change_str.match?(/\A\d/) && change_str.to_f.positive?)
          :up
        elsif change_str.start_with?("-") || change_str.to_f.negative?
          :down
        else
          :neutral
        end
      end
    end
  end
end
