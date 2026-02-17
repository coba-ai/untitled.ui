# frozen_string_literal: true

require_relative "lib/untitled_ui/version"

Gem::Specification.new do |spec|
  spec.name        = "untitled_ui"
  spec.version     = UntitledUi::VERSION
  spec.authors     = ["Factor Team"]
  spec.email       = ["dev@factor.com"]
  spec.homepage    = "https://github.com/factor/untitled_ui"
  spec.summary     = "Untitled UI design system components for Rails"
  spec.description = "A ViewComponent-based design system implementing Untitled UI tokens, components, and patterns for Rails applications with Tailwind CSS."
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.1"

  spec.files = Dir[
    "app/**/*",
    "config/**/*",
    "lib/**/*",
    "LICENSE.txt",
    "README.md"
  ]

  spec.add_dependency "rails", ">= 7.1"
  spec.add_dependency "view_component", ">= 3.0"
end
