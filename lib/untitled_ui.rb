# frozen_string_literal: true

require "view_component"
require "untitled_ui/version"
require "untitled_ui/configuration"
require "untitled_ui/engine"

module UntitledUi
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def gem_root
      Pathname.new(File.expand_path("../..", __FILE__))
    end
  end
end
