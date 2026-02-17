# frozen_string_literal: true

module Ui
  module Navigation
    module ItemButton
      class Component < Ui::Base
        SIZE_STYLES = {
          md: { root: "size-10", icon: "size-5" },
          lg: { root: "size-12", icon: "size-6" }
        }.freeze

        attr_reader :label, :href, :icon, :current, :size, :tooltip_placement, :extra_classes

        def initialize(label:, icon:, href: nil, current: false, size: :md, tooltip_placement: :right, class: nil, **_opts)
          @label = label
          @icon = icon
          @href = href
          @current = current
          @size = size.to_sym
          @tooltip_placement = tooltip_placement.to_sym
          @extra_classes = binding.local_variable_get(:class)
        end

        def root_classes
          cx(
            "relative flex w-full cursor-pointer items-center justify-center rounded-md bg-primary p-2 text-fg-quaternary outline-focus-ring transition duration-100 ease-linear select-none hover:bg-primary_hover hover:text-fg-quaternary_hover focus-visible:z-10 focus-visible:outline-2 focus-visible:outline-offset-2",
            @current && "bg-active text-fg-quaternary_hover hover:bg-secondary_hover",
            SIZE_STYLES.dig(@size, :root),
            @extra_classes
          )
        end

        def icon_classes
          cx("shrink-0 transition-inherit-all", SIZE_STYLES.dig(@size, :icon))
        end
      end
    end
  end
end
