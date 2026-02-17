# frozen_string_literal: true

module Ui
  module Concerns
    # Provides a declarative variant system for ViewComponents.
    # Supports multi-dimensional variants with defaults and validation.
    #
    # Usage:
    #   class MyComponent < Ui::Base
    #     VARIANTS = {
    #       size: {
    #         sm: "text-sm px-2 py-1",
    #         md: "text-md px-3 py-2",
    #         lg: "text-lg px-4 py-3"
    #       },
    #       color: {
    #         primary: "bg-brand-solid text-white",
    #         secondary: "bg-primary text-secondary"
    #       }
    #     }.freeze
    #
    #     DEFAULTS = { size: :sm, color: :primary }.freeze
    #   end
    module HasVariants
      extend ActiveSupport::Concern

      class_methods do
        # Returns the variant classes for the given dimension and value.
        #
        # @param dimension [Symbol] the variant dimension (e.g., :size, :color)
        # @param value [Symbol] the variant value (e.g., :sm, :primary)
        # @return [String, nil] the CSS classes for the variant
        def variant_classes(dimension, value)
          variants = const_defined?(:VARIANTS) ? const_get(:VARIANTS) : {}
          variants.dig(dimension, value&.to_sym)
        end

        # Returns the default value for a given variant dimension.
        #
        # @param dimension [Symbol] the variant dimension
        # @return [Symbol, nil] the default value
        def variant_default(dimension)
          defaults = const_defined?(:DEFAULTS) ? const_get(:DEFAULTS) : {}
          defaults[dimension]
        end

        # Validates a variant value against allowed values.
        #
        # @param dimension [Symbol] the variant dimension
        # @param value [Symbol] the value to validate
        # @return [Symbol] the validated value (or the default if invalid)
        def validate_variant(dimension, value)
          variants = const_defined?(:VARIANTS) ? const_get(:VARIANTS) : {}
          allowed = variants[dimension]&.keys || []
          val = value&.to_sym

          if allowed.include?(val)
            val
          else
            variant_default(dimension) || allowed.first
          end
        end
      end

      private

      # Convenience method for instances to resolve variant classes
      def variant_classes(dimension, value)
        self.class.variant_classes(dimension, value)
      end

      # Convenience method for instances to validate a variant
      def validate_variant(dimension, value)
        self.class.validate_variant(dimension, value)
      end
    end
  end
end
