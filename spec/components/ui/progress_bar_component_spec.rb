require "rails_helper"

RSpec.describe Ui::ProgressBar::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new(value: 50))

    expect(page).to have_css("[role='progressbar']")
  end

  it "renders with label" do
    render_inline(described_class.new(value: 75, label_position: :right))

    expect(page).to have_text("75%")
  end

  it "calculates percentage correctly" do
    component = described_class.new(value: 25, min: 0, max: 100)
    expect(component.percentage).to eq(25.0)
  end
end
