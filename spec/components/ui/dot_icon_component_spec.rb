require "rails_helper"

RSpec.describe Ui::DotIcon::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new)

    expect(page).to have_css("svg")
  end

  it "renders all size variants" do
    %i[sm md lg].each do |size|
      render_inline(described_class.new(size: size))
      expect(page).to have_css("svg")
    end
  end

  it "renders with color class" do
    render_inline(described_class.new(color: "text-error-primary"))

    expect(page).to have_css("svg.text-error-primary")
  end
end
