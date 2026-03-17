# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::Card::Component, type: :component do
  it "renders with default settings and body content" do
    render_inline(described_class.new) { "Card body" }

    expect(page).to have_text("Card body")
    expect(page).to have_css("div.bg-primary")
  end

  it "renders header slot with bottom border" do
    render_inline(described_class.new) do |card|
      card.with_header { "Card Header" }
      "Body"
    end

    expect(page).to have_text("Card Header")
    expect(page).to have_css("div.border-b")
  end

  it "renders footer slot with top border" do
    render_inline(described_class.new) do |card|
      card.with_footer { "Card Footer" }
      "Body"
    end

    expect(page).to have_text("Card Footer")
    expect(page).to have_css("div.border-t")
  end

  it "renders media slot at the top" do
    render_inline(described_class.new) do |card|
      card.with_media { '<img src="test.jpg" alt="Test" />'.html_safe }
      "Body"
    end

    expect(page).to have_css("img[src='test.jpg']")
  end

  it "renders media above header when both are present" do
    render_inline(described_class.new) do |card|
      card.with_media { '<img src="test.jpg" alt="Test" />'.html_safe }
      card.with_header { "Header" }
      "Body"
    end

    expect(page).to have_css("img + div.border-b")
  end

  context "padding variants" do
    it "applies small padding" do
      render_inline(described_class.new(padding: :sm)) { "Body" }

      expect(page).to have_css("div.p-4")
    end

    it "applies medium padding by default" do
      render_inline(described_class.new) { "Body" }

      expect(page).to have_css("div.p-6")
    end

    it "applies large padding" do
      render_inline(described_class.new(padding: :lg)) { "Body" }

      expect(page).to have_css("div.p-8")
    end
  end

  context "shadow variants" do
    it "applies no shadow" do
      render_inline(described_class.new(shadow: :none)) { "Body" }

      expect(page).not_to have_css("div.shadow-xs")
      expect(page).not_to have_css("div.shadow-md")
      expect(page).not_to have_css("div.shadow-lg")
    end

    it "applies small shadow by default" do
      render_inline(described_class.new) { "Body" }

      expect(page).to have_css("div.shadow-xs")
    end

    it "applies medium shadow" do
      render_inline(described_class.new(shadow: :md)) { "Body" }

      expect(page).to have_css("div.shadow-md")
    end

    it "applies large shadow" do
      render_inline(described_class.new(shadow: :lg)) { "Body" }

      expect(page).to have_css("div.shadow-lg")
    end
  end

  context "border option" do
    it "renders with border by default" do
      render_inline(described_class.new) { "Body" }

      expect(page).to have_css("div.ring-1")
    end

    it "renders without border when disabled" do
      render_inline(described_class.new(border: false)) { "Body" }

      expect(page).not_to have_css("div.ring-1")
    end
  end

  context "rounded option" do
    it "renders with rounded corners by default" do
      render_inline(described_class.new) { "Body" }

      expect(page).to have_css("div.rounded-xl")
    end

    it "renders without rounded corners when disabled" do
      render_inline(described_class.new(rounded: false)) { "Body" }

      expect(page).not_to have_css("div.rounded-xl")
    end
  end

  it "accepts custom CSS classes" do
    render_inline(described_class.new(class: "custom-class")) { "Body" }

    expect(page).to have_css("div.custom-class")
  end
end
