# frozen_string_literal: true

module Ui
  module Navigation
    module Item
      class Component < Ui::Base
        TYPE_STYLES = {
          link: "px-3 py-2",
          collapsible: "px-3 py-2",
          collapsible_child: "py-2 pr-3 pl-10"
        }.freeze

        attr_reader :type, :href, :icon, :badge, :current, :truncate, :extra_classes

        def initialize(type: :link, href: nil, icon: nil, badge: nil, current: false, truncate: true, class: nil, **_opts)
          @type = type.to_sym
          @href = href
          @icon = icon
          @badge = badge
          @current = current
          @truncate = truncate
          @extra_classes = binding.local_variable_get(:class)
        end

        def root_classes
          cx(
            "group relative flex w-full cursor-pointer items-center rounded-md bg-primary outline-focus-ring transition duration-100 ease-linear select-none hover:bg-primary_hover focus-visible:z-10 focus-visible:outline-2 focus-visible:outline-offset-2",
            TYPE_STYLES[@type],
            @current && "bg-active hover:bg-secondary_hover",
            @extra_classes
          )
        end

        def label_classes
          cx(
            "flex-1 text-md font-semibold text-secondary transition-inherit-all group-hover:text-secondary_hover",
            @truncate && "truncate",
            @current && "text-secondary_hover"
          )
        end

        def icon_classes
          "mr-2 size-5 shrink-0 text-fg-quaternary transition-inherit-all"
        end

        def external?
          @href&.start_with?("http")
        end

        def link_attrs
          attrs = {}
          attrs[:href] = @href if @href.present?
          attrs[:target] = "_blank" if external?
          attrs[:rel] = "noopener noreferrer" if external?
          attrs[:"aria-current"] = "page" if @current
          attrs
        end
      end
    end
  end
end
