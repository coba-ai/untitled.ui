# frozen_string_literal: true

module Ui
  module Pagination
    module Dot
      class Component < Ui::Base
        SIZE_STYLES = {
          md: { root: "gap-3", framed: "p-2", dot: "h-2 w-2" },
          lg: { root: "gap-4", framed: "p-3", dot: "h-2.5 w-2.5" }
        }.freeze

        attr_reader :current_page, :total_pages, :size, :brand, :framed, :extra_classes

        def initialize(current_page: 1, total_pages: 3, size: :md, brand: false, framed: false, page_url: nil, class: nil, **_opts)
          @current_page = current_page.to_i
          @total_pages = [total_pages.to_i, 1].max
          @size = size.to_sym
          @brand = brand
          @framed = framed
          @page_url = page_url
          @extra_classes = binding.local_variable_get(:class)
        end

        def page_url(page)
          if @page_url.respond_to?(:call)
            @page_url.call(page)
          else
            "?page=#{page}"
          end
        end

        def root_classes
          cx(
            "flex h-max w-max",
            SIZE_STYLES.dig(@size, :root),
            @framed && SIZE_STYLES.dig(@size, :framed),
            @framed && "rounded-full bg-alpha-white/90 backdrop-blur",
            @extra_classes
          )
        end

        def dot_classes(page)
          cx(
            "block cursor-pointer rounded-full outline-focus-ring focus-visible:outline-2 focus-visible:outline-offset-2",
            SIZE_STYLES.dig(@size, :dot),
            @brand ? "bg-fg-brand-secondary" : "bg-quaternary",
            page == @current_page && (@brand ? "bg-fg-white" : "bg-fg-brand-primary_alt")
          )
        end
      end
    end
  end
end
