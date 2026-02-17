# frozen_string_literal: true

module Ui
  # Utility for merging CSS class names. Handles strings, arrays, hashes, and nil values.
  # Designed as a lightweight Tailwind-merge-compatible class merger for ViewComponents.
  #
  # Usage:
  #   Ui::ClassNames.cx("px-4 py-2", "text-sm", active && "bg-blue-500")
  #   Ui::ClassNames.cx(["px-4", "py-2"], nil, "text-sm")
  module ClassNames
    module_function

    # Merges multiple class name arguments into a single string.
    # Accepts strings, arrays, hashes (keys as classes, values as conditions), and nil.
    #
    # @param args [Array<String, Array, Hash, nil>] class name arguments
    # @return [String] merged class string
    def cx(*args)
      args
        .flatten
        .compact
        .flat_map { |arg| resolve(arg) }
        .reject(&:blank?)
        .join(" ")
        .squish
    end

    # @api private
    def resolve(arg)
      case arg
      when String
        arg
      when Hash
        arg.filter_map { |klass, condition| klass.to_s if condition }
      when Array
        arg.flat_map { |a| resolve(a) }
      else
        arg.to_s
      end
    end
    private_class_method :resolve
  end
end
