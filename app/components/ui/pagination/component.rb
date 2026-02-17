# frozen_string_literal: true

module Ui
  module Pagination
    class Component < Ui::Base
      VALID_TYPES = %i[page_default page_minimal card_default card_minimal].freeze

      attr_reader :type, :current_page, :total_pages, :rounded, :align, :extra_classes

      def initialize(
        type: :page_default,
        current_page: 1,
        total_pages: 10,
        page_url: nil,
        rounded: false,
        align: :left,
        sibling_count: 1,
        class: nil,
        **_opts
      )
        @type = type.to_sym
        raise ArgumentError, "Invalid pagination type: #{@type}" unless VALID_TYPES.include?(@type)

        @current_page = current_page.to_i
        @total_pages = [total_pages.to_i, 1].max
        @page_url = page_url
        @rounded = rounded
        @align = align.to_sym
        @sibling_count = sibling_count
        @extra_classes = binding.local_variable_get(:class)
      end

      def page_url(page)
        if @page_url.respond_to?(:call)
          @page_url.call(page)
        else
          "?page=#{page}"
        end
      end

      def prev_url
        return nil if first_page?
        page_url(@current_page - 1)
      end

      def next_url
        return nil if last_page?
        page_url(@current_page + 1)
      end

      def first_page?
        @current_page <= 1
      end

      def last_page?
        @current_page >= @total_pages
      end

      def pages
        @pages ||= build_pages
      end

      def minimal_type?
        @type == :card_minimal
      end

      def root_classes
        case @type
        when :page_default, :page_minimal
          cx("flex w-full items-center justify-between gap-3 border-t border-secondary pt-4 md:pt-5", @extra_classes)
        when :card_default
          cx("flex w-full items-center justify-between gap-3 border-t border-secondary px-4 py-3 md:px-6 md:pt-3 md:pb-4", @extra_classes)
        when :card_minimal
          cx("border-t border-secondary px-4 py-3 md:px-6 md:pt-3 md:pb-4", @extra_classes)
        end
      end

      def page_item_classes(page_number)
        cx(
          "flex size-10 cursor-pointer items-center justify-center p-3 text-sm font-medium text-quaternary outline-focus-ring transition duration-100 ease-linear hover:bg-primary_hover hover:text-secondary focus-visible:z-10 focus-visible:bg-primary_hover focus-visible:outline-2 focus-visible:outline-offset-2",
          @rounded ? "rounded-full" : "rounded-lg",
          page_number == @current_page && "bg-primary_hover text-secondary"
        )
      end

      private

      def build_pages
        items = []
        total_page_numbers = @sibling_count * 2 + 5

        if total_page_numbers >= @total_pages
          (1..@total_pages).each { |i| items << { type: :page, value: i } }
        else
          left_sibling = [@current_page - @sibling_count, 1].max
          right_sibling = [@current_page + @sibling_count, @total_pages].min

          show_left_ellipsis = left_sibling > 2
          show_right_ellipsis = right_sibling < @total_pages - 1

          if !show_left_ellipsis && show_right_ellipsis
            left_count = @sibling_count * 2 + 3
            (1..left_count).each { |i| items << { type: :page, value: i } }
            items << { type: :ellipsis }
            items << { type: :page, value: @total_pages }
          elsif show_left_ellipsis && !show_right_ellipsis
            right_count = @sibling_count * 2 + 3
            items << { type: :page, value: 1 }
            items << { type: :ellipsis }
            ((@total_pages - right_count + 1)..@total_pages).each { |i| items << { type: :page, value: i } }
          elsif show_left_ellipsis && show_right_ellipsis
            items << { type: :page, value: 1 }
            items << { type: :ellipsis }
            (left_sibling..right_sibling).each { |i| items << { type: :page, value: i } }
            items << { type: :ellipsis }
            items << { type: :page, value: @total_pages }
          end
        end

        items
      end
    end
  end
end
