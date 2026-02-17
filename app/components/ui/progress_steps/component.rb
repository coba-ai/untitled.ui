# frozen_string_literal: true

module Ui
  module ProgressSteps
    class Component < Ui::Base
      # Each step: { title:, description: (optional), icon: (optional SVG string) }
      # Steps before current_step are "completed", current_step is "current", rest are "upcoming".

      attr_reader :steps, :current_step, :extra_classes

      def initialize(steps: [], current_step: 0, class: nil, **_opts)
        @steps = steps
        @current_step = current_step
        @extra_classes = binding.local_variable_get(:class)
      end

      def root_classes
        cx("flex w-full items-start", @extra_classes)
      end

      def step_state(index)
        if index < @current_step
          :completed
        elsif index == @current_step
          :current
        else
          :upcoming
        end
      end

      def icon_outer_classes(state)
        cx(
          "relative z-10 flex size-8 shrink-0 items-center justify-center rounded-full border-2",
          case state
          when :completed then "border-brand-solid bg-brand-solid"
          when :current then "border-brand-solid bg-primary"
          else "border-secondary bg-primary"
          end
        )
      end

      def icon_inner_classes(state)
        cx(
          "size-4 shrink-0",
          case state
          when :completed then "text-white"
          when :current then "text-fg-brand-primary"
          else "text-fg-quaternary"
          end
        )
      end

      def dot_classes(state)
        cx(
          "size-2.5 rounded-full",
          case state
          when :current then "bg-brand-solid"
          else "bg-quaternary"
          end
        )
      end

      def title_classes(state)
        cx(
          "text-sm font-semibold",
          state == :upcoming ? "text-tertiary" : "text-brand-secondary"
        )
      end

      def description_classes(state)
        cx(
          "text-sm",
          state == :upcoming ? "text-quaternary" : "text-tertiary"
        )
      end

      def connector_classes(state)
        cx(
          "h-0.5 w-full",
          state == :completed ? "bg-brand-solid" : "bg-secondary"
        )
      end

      def checkmark_svg
        '<svg fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5" /></svg>'
      end
    end
  end
end
