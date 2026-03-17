# frozen_string_literal: true

module UntitledUi
  module ThemeHelper
    def untitled_ui_theme_class
      theme = UntitledUi.configuration.theme
      theme == :default ? "" : "#{theme}-theme"
    end

    def untitled_ui_available_themes
      themes = [{ name: "Default", value: "", has_dark: false }]
      dark_variants = []

      # Scan host app for generated theme CSS files
      host_themes_dir = Rails.root.join("app", "assets", "tailwind", "untitled_ui")
      if host_themes_dir.directory?
        Dir.glob(host_themes_dir.join("*.css")).each do |file|
          content = File.read(file)
          if (match = content.match(/\.([a-zA-Z0-9_-]+-theme)\s*\{/))
            theme_class = match[1]
            if theme_class.start_with?("dark_") || theme_class == "dark-theme"
              dark_variants << theme_class
            else
              theme_name = theme_class.sub("-theme", "").titleize
              themes << { name: theme_name, value: theme_class, has_dark: false } unless themes.any? { |t| t[:value] == theme_class }
            end
          end
        end
      end

      # Add hacker theme (no dark variant)
      themes << { name: "Hacker", value: "hacker-theme", has_dark: false } unless themes.any? { |t| t[:value] == "hacker-theme" }

      # Mark themes that have dark variants
      themes.each do |theme|
        base_name = theme[:value].sub("-theme", "")
        dark_class = "dark_#{base_name}-theme"
        theme[:has_dark] = dark_variants.include?(dark_class)
      end

      # Check if default has a dark variant
      themes.first[:has_dark] = dark_variants.include?("dark-theme")

      themes
    end
  end
end
