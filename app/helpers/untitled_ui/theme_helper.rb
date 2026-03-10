# frozen_string_literal: true

module UntitledUi
  module ThemeHelper
    def untitled_ui_theme_class
      UntitledUi.configuration.theme == :hacker ? "hacker-theme" : ""
    end
  end
end
