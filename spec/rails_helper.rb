# frozen_string_literal: true

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "dummy/config/environment"

require "rspec/rails"
require "view_component/test_helpers"
require "capybara/rspec"

RSpec.configure do |config|
  config.include ViewComponent::TestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
