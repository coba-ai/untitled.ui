# frozen_string_literal: true

require "rails_helper"

RSpec.describe UntitledUi::ThemeHelper, type: :helper do
  describe "#untitled_ui_theme_class" do
    it "returns empty string when theme is :default" do
      UntitledUi.configuration.theme = :default
      expect(helper.untitled_ui_theme_class).to eq("")
    end

    it "returns 'hacker-theme' when theme is :hacker" do
      UntitledUi.configuration.theme = :hacker
      expect(helper.untitled_ui_theme_class).to eq("hacker-theme")
    end

    it "returns 'ocean-theme' when theme is :ocean" do
      UntitledUi.configuration.theme = :ocean
      expect(helper.untitled_ui_theme_class).to eq("ocean-theme")
    end

    after do
      UntitledUi.configuration.theme = :default
    end
  end
end
