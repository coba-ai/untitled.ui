# frozen_string_literal: true

module UntitledUi
  module ThemeHelper
    def untitled_ui_theme_class
      theme = UntitledUi.configuration.theme
      theme == :default ? "" : "#{theme}-theme"
    end
  end
end
