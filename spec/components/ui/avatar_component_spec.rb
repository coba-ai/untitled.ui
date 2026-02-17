require "rails_helper"

RSpec.describe Ui::Avatar::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new)

    expect(page).to have_css("div")
  end

  it "renders with initials" do
    render_inline(described_class.new(initials: "AK"))

    expect(page).to have_text("AK")
  end

  it "renders all size variants" do
    %i[xxs xs sm md lg xl].each do |size|
      render_inline(described_class.new(size: size, initials: "AB"))
      expect(page).to have_text("AB")
    end
  end

  it "renders status indicator" do
    render_inline(described_class.new(status: :online, initials: "X"))

    expect(page).to have_css("span") # status dot
  end
end
