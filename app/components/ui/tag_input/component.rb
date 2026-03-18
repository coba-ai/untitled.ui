# frozen_string_literal: true

module Ui
  module TagInput
    class Component < Ui::Base
      WRAPPER_CLASSES = "relative flex w-full flex-row flex-wrap place-items-center gap-1.5 rounded-lg bg-primary shadow-xs ring-1 ring-primary transition-shadow duration-100 ease-linear ring-inset px-2 py-1.5 min-h-[38px]"
      INPUT_CLASSES = "m-0 min-w-[120px] flex-1 bg-transparent text-md text-primary ring-0 outline-hidden placeholder:text-placeholder py-0.5 px-1"
      TAG_CLASSES = "inline-flex items-center gap-1 rounded-md bg-utility-brand-50 px-2 py-0.5 text-sm font-medium text-utility-brand-700 ring-1 ring-inset ring-utility-brand-200"
      TAG_REMOVE_CLASSES = "inline-flex size-3.5 shrink-0 items-center justify-center rounded-sm text-utility-brand-400 hover:bg-utility-brand-200 hover:text-utility-brand-600 focus:outline-none"

      attr_reader :label, :hint, :placeholder, :disabled, :invalid, :name,
                  :id, :extra_classes, :max_tags, :initial_tags

      def initialize(
        name: nil, value: nil, placeholder: "Add a tag...", label: nil,
        hint: nil, disabled: false, invalid: false, max_tags: nil,
        id: nil, class: nil, **_opts
      )
        @name = name
        @label = label
        @hint = hint
        @placeholder = placeholder
        @disabled = disabled
        @invalid = invalid
        @max_tags = max_tags
        @id = id
        @extra_classes = binding.local_variable_get(:class)
        @initial_tags = parse_value(value)
      end

      def wrapper_classes
        cx(
          WRAPPER_CLASSES,
          "focus-within:ring-2 focus-within:ring-brand",
          @disabled && "cursor-not-allowed bg-disabled_subtle ring-disabled",
          @invalid && "ring-error_subtle",
          @invalid && "focus-within:ring-2 focus-within:ring-error"
        )
      end

      def input_classes
        cx(
          INPUT_CLASSES,
          @disabled && "cursor-not-allowed text-disabled"
        )
      end

      def tag_classes
        TAG_CLASSES
      end

      def tag_remove_classes
        TAG_REMOVE_CLASSES
      end

      def initial_value
        @initial_tags.join(",")
      end

      private

      def parse_value(value)
        return [] if value.nil?

        if value.is_a?(Array)
          value.map(&:to_s).reject(&:blank?)
        else
          value.to_s.split(",").map(&:strip).reject(&:blank?)
        end
      end
    end
  end
end
