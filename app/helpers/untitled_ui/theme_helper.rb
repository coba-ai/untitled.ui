# frozen_string_literal: true

module UntitledUi
  module ThemeHelper
    def untitled_ui_theme_class
      theme = UntitledUi.configuration.theme
      theme == :default ? "" : "#{theme}-theme"
    end

    def untitled_ui_available_themes
      themes = [{ name: "Default", value: "" }, { name: "Hacker", value: "hacker-theme" }]

      # Scan host app for generated theme CSS files
      host_themes_dir = Rails.root.join("app", "assets", "tailwind", "untitled_ui")
      if host_themes_dir.directory?
        Dir.glob(host_themes_dir.join("*.css")).each do |file|
          content = File.read(file)
          if (match = content.match(/\.([a-zA-Z0-9_-]+-theme)\s*\{/))
            theme_class = match[1]
            theme_name = theme_class.sub("-theme", "").titleize
            themes << { name: theme_name, value: theme_class } unless themes.any? { |t| t[:value] == theme_class }
          end
        end
      end

      themes
    end
  end
end
