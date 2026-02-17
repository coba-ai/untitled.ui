# frozen_string_literal: true

module Ui
  # Base class for all UI components. Provides class merging, variant support,
  # and common patterns used across the design system.
  class Base < ViewComponent::Base
    include Ui::Concerns::HasVariants

    # Merge CSS class names using the ClassNames utility
    #
    # @param args [Array<String, Array, Hash, nil>] class name arguments
    # @return [String] merged class string
    def cx(*args)
      Ui::ClassNames.cx(*args)
    end

    # Generates an HTML tag with the given name, attributes, and optional content.
    # Supports polymorphic rendering (button/a/div/span).
    #
    # @param tag_name [Symbol] the HTML tag to render
    # @param attrs [Hash] HTML attributes
    # @param block [Proc] optional block for content
    # @return [String] rendered HTML
    def polymorphic_tag(tag_name, **attrs, &block)
      content_tag(tag_name, **attrs, &block)
    end

    private

    # Passes extra HTML attributes through to the root element.
    # Filters out component-specific params, leaving only HTML-safe attributes.
    #
    # @param attrs [Hash] all attributes
    # @param except [Array<Symbol>] keys to exclude
    # @return [Hash] filtered HTML attributes
    def html_attrs(attrs, except: [])
      attrs.except(*except)
    end
  end
end
