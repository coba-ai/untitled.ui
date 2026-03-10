# frozen_string_literal: true

module UntitledUi
  class Configuration
    attr_accessor :design_system_enabled, :theme

    def initialize
      @design_system_enabled = true
      @theme = :default
    end
  end
end
