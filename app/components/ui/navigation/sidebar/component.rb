# frozen_string_literal: true

module Ui
  module Navigation
    module Sidebar
      class Component < Ui::Base
        VARIANT_WIDTHS = {
          simple: { main: 296 },
          slim: { main: 68, secondary: 268 },
          dual_tier: { main: 296, secondary: 256 },
          section_dividers: { main: 292 },
          section_subheadings: { main: 292 }
        }.freeze

        VALID_TYPES = VARIANT_WIDTHS.keys.freeze

        attr_reader :type, :active_url, :items, :footer_items, :hide_border, :show_account_card, :extra_classes

        renders_one :logo
        renders_one :search
        renders_one :feature_card
        renders_one :account_card

        def initialize(type: :simple, active_url: nil, items: [], footer_items: [], hide_border: false, show_account_card: true, class: nil, **_opts)
          @type = type.to_sym
          raise ArgumentError, "Invalid sidebar type: #{@type}. Must be one of: #{VALID_TYPES.join(', ')}" unless VALID_TYPES.include?(@type)

          @active_url = active_url
          @items = items
          @footer_items = footer_items
          @hide_border = hide_border
          @show_account_card = show_account_card
          @extra_classes = binding.local_variable_get(:class)
        end

        def main_width
          VARIANT_WIDTHS.dig(@type, :main)
        end

        def secondary_width
          VARIANT_WIDTHS.dig(@type, :secondary)
        end

        def has_secondary_panel?
          @type.in?(%i[slim dual_tier])
        end

        def card_style?
          @type.in?(%i[section_dividers section_subheadings])
        end

        def variant_partial
          "ui/navigation/sidebar/#{@type}"
        end
      end
    end
  end
end
