# frozen_string_literal: true

module UntitledUi
  class Configuration
    attr_accessor :design_system_enabled

    def initialize
      @design_system_enabled = true
    end
  end
end
