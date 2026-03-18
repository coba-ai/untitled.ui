# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::Skeleton::Component, type: :component do
  it "renders with default props (text variant)" do
    render_inline(described_class.new)

    expect(page).to have_css("[aria-hidden='true']")
    expect(page).to have_css("span.animate-pulse", count: 3)
  end

  it "renders text variant with correct number of lines" do
    render_inline(described_class.new(variant: :text, lines: 5))

    expect(page).to have_css("span.animate-pulse", count: 5)
  end

  it "renders the last text line at 3/4 width" do
    render_inline(described_class.new(variant: :text, lines: 3))

    spans = page.all("span.animate-pulse")
    expect(spans.last[:class]).to include("w-3/4")
    expect(spans.first[:class]).to include("w-full")
  end

  it "renders circular variant" do
    render_inline(described_class.new(variant: :circular, width: "40px", height: "40px"))

    expect(page).to have_css("span.rounded-full")
  end

  it "renders rectangular variant" do
    render_inline(described_class.new(variant: :rectangular, width: "100%", height: "200px"))

    expect(page).to have_css("span.rounded-lg")
  end

  it "renders without animation when animated: false" do
    render_inline(described_class.new(animated: false))

    expect(page).not_to have_css(".animate-pulse")
  end

  it "applies inline styles for width and height on non-text variants" do
    render_inline(described_class.new(variant: :circular, width: "48px", height: "48px"))

    expect(page).to have_css("span[style*='width: 48px']")
    expect(page).to have_css("span[style*='height: 48px']")
  end

  it "applies extra classes" do
    render_inline(described_class.new(variant: :rectangular, class: "my-custom-class"))

    expect(page).to have_css("span.my-custom-class")
  end

  it "renders all variant types" do
    %i[text circular rectangular].each do |variant|
      render_inline(described_class.new(variant: variant))
      expect(page).to have_css("[aria-hidden='true']")
    end
  end
end
