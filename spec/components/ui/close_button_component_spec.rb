require "rails_helper"

RSpec.describe Ui::CloseButton::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new)

    expect(page).to have_css("button[aria-label='Close']")
  end

  it "renders custom aria label" do
    render_inline(described_class.new(label: "Dismiss"))

    expect(page).to have_css("button[aria-label='Dismiss']")
  end

  it "renders all size variants" do
    %i[xs sm md lg].each do |size|
      render_inline(described_class.new(size: size))
      expect(page).to have_css("button")
    end
  end

  it "renders both theme variants" do
    %i[light dark].each do |theme|
      render_inline(described_class.new(theme: theme))
      expect(page).to have_css("button")
    end
  end
end
