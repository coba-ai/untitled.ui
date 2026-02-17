require "rails_helper"

RSpec.describe Ui::Navigation::AccountCard::Component, type: :component do
  it "renders name and email" do
    render_inline(described_class.new(name: "John Doe", email: "john@example.com"))

    expect(page).to have_text("John Doe")
    expect(page).to have_text("john@example.com")
  end

  it "renders avatar" do
    render_inline(described_class.new(name: "John Doe", email: "john@example.com", avatar_src: "https://example.com/avatar.jpg"))

    expect(page).to have_css("img[src='https://example.com/avatar.jpg']")
  end

  it "renders menu slot with dropdown trigger" do
    render_inline(described_class.new(name: "John Doe", email: "john@example.com")) do |card|
      card.with_menu { "<p>Menu content</p>".html_safe }
    end

    expect(page).to have_css("[data-controller='dropdown']")
  end
end
