# frozen_string_literal: true

module Ui
  module Select
    class Component < Ui::Base
      SIZE_STYLES = {
        sm: { root: "px-3 py-2", icon: "right-3" },
        md: { root: "px-3.5 py-2.5", icon: "right-3.5" }
      }.freeze

      WRAPPER_CLASSES = "relative flex w-full flex-row place-content-center place-items-center rounded-lg bg-primary shadow-xs ring-1 ring-primary transition-shadow duration-100 ease-linear ring-inset"
      TRIGGER_CLASSES = "m-0 w-full cursor-pointer bg-transparent text-md text-primary ring-0 outline-hidden text-left"
      DROPDOWN_CLASSES = "absolute left-0 top-full z-50 mt-1 max-h-60 w-full overflow-auto rounded-lg bg-primary shadow-lg ring-1 ring-secondary_alt"
      OPTION_CLASSES = "cursor-pointer select-none px-3 py-2 text-sm text-secondary transition duration-100 ease-linear"
      SEARCH_CLASSES = "w-full border-b border-primary bg-transparent px-3 py-2 text-sm text-primary outline-hidden placeholder:text-placeholder"

      attr_reader :size, :label, :hint, :placeholder, :required, :invalid,
                  :disabled, :name, :value, :id, :extra_classes, :options,
                  :searchable

      def initialize(
        options: [], size: :sm, label: nil, hint: nil, placeholder: "Select...",
        required: false, invalid: false, disabled: false, name: nil, value: nil,
        id: nil, searchable: false, class: nil, **_opts
      )
        @options = normalize_options(options)
        @size = size.to_sym
        @label = label
        @hint = hint
        @placeholder = placeholder
        @required = required
        @invalid = invalid
        @disabled = disabled
        @name = name
        @value = value
        @id = id
        @searchable = searchable
        @extra_classes = binding.local_variable_get(:class)
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

      def trigger_classes
        cx(
          TRIGGER_CLASSES,
          SIZE_STYLES.dig(@size, :root),
          "pr-9",
          @disabled && "cursor-not-allowed text-disabled"
        )
      end

      def chevron_classes
        cx(
          "pointer-events-none absolute size-5 text-fg-quaternary",
          @disabled && "text-fg-disabled",
          SIZE_STYLES.dig(@size, :icon)
        )
      end

      def dropdown_classes
        DROPDOWN_CLASSES
      end

      def option_classes
        OPTION_CLASSES
      end

      def search_classes
        SEARCH_CLASSES
      end

      def selected_label
        selected = @options.find { |opt| opt[:value].to_s == @value.to_s }
        selected ? selected[:label] : nil
      end

      def options_json
        @options.to_json
      end

      private

      def normalize_options(opts)
        opts.map do |opt|
          if opt.is_a?(Array)
            { label: opt[0].to_s, value: opt[1].to_s }
          elsif opt.is_a?(Hash)
            { label: opt[:label].to_s, value: opt[:value].to_s }
          else
            { label: opt.to_s, value: opt.to_s }
          end
        end
      end
    end
  end
end
