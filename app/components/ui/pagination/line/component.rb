# frozen_string_literal: true

module Ui
  module Pagination
    module Line
      class Component < Ui::Base
        SIZE_STYLES = {
          md: { root: "gap-2", framed: "p-2", line: "h-1.5 w-full" },
          lg: { root: "gap-3", framed: "p-3", line: "h-2 w-full" }
        }.freeze

        attr_reader :current_page, :total_pages, :size, :framed, :extra_classes

        def initialize(current_page: 1, total_pages: 3, size: :md, framed: false, page_url: nil, class: nil, **_opts)
          @current_page = current_page.to_i
          @total_pages = [total_pages.to_i, 1].max
          @size = size.to_sym
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

        def line_classes(page)
          cx(
            "block cursor-pointer rounded-full bg-quaternary outline-focus-ring focus-visible:outline-2 focus-visible:outline-offset-2",
            SIZE_STYLES.dig(@size, :line),
            page == @current_page && "bg-fg-brand-primary_alt"
          )
        end
      end
    end
  end
end
