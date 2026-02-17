require "rails_helper"

RSpec.describe Ui::Navigation::Item::Component, type: :component do
  let(:icon_svg) { '<svg class="size-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path d="M12 6v12" /></svg>' }

  describe "link type" do
    it "renders a link" do
      render_inline(described_class.new(type: :link, href: "/dashboard")) { "Dashboard" }

      expect(page).to have_link("Dashboard", href: "/dashboard")
    end

    it "renders with icon" do
      render_inline(described_class.new(type: :link, href: "/home", icon: icon_svg)) { "Home" }

      expect(page).to have_css("span[aria-hidden='true']")
      expect(page).to have_text("Home")
    end

    it "renders with badge" do
      render_inline(described_class.new(type: :link, href: "/inbox", badge: "5")) { "Inbox" }

      expect(page).to have_text("5")
      expect(page).to have_text("Inbox")
    end

    it "applies active styles when current" do
      render_inline(described_class.new(type: :link, href: "/home", current: true)) { "Home" }

      expect(page).to have_css("a[aria-current='page']")
      expect(page).to have_css("a.bg-active")
    end

    it "renders external link with target blank" do
      render_inline(described_class.new(type: :link, href: "https://example.com")) { "External" }

      expect(page).to have_css("a[target='_blank'][rel='noopener noreferrer']")
    end
  end

  describe "collapsible type" do
    it "renders a summary element" do
      render_inline(described_class.new(type: :collapsible)) { "Settings" }

      expect(page).to have_css("summary[role='button']")
      expect(page).to have_text("Settings")
    end

    it "renders chevron icon" do
      render_inline(described_class.new(type: :collapsible)) { "Settings" }

      expect(page).to have_css("summary svg")
    end
  end

  describe "collapsible_child type" do
    it "renders a link with indented padding" do
      render_inline(described_class.new(type: :collapsible_child, href: "/settings/profile")) { "Profile" }

      expect(page).to have_link("Profile", href: "/settings/profile")
      expect(page).to have_css("a.pl-10")
    end
  end
end
