require "rails_helper"

RSpec.describe Ui::FeaturedIcon::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new)

    expect(page).to have_css("div")
  end

  it "renders all theme variants" do
    %i[light dark modern outline].each do |theme|
      render_inline(described_class.new(theme: theme))
      expect(page).to have_css("div")
    end
  end

  it "renders all size variants" do
    %i[sm md lg xl].each do |size|
      render_inline(described_class.new(size: size))
      expect(page).to have_css("div")
    end
  end

  it "renders custom content" do
    render_inline(described_class.new) { "<span>Icon</span>".html_safe }

    expect(page).to have_text("Icon")
  end
end
