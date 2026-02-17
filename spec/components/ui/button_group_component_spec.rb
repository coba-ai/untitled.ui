require "rails_helper"

RSpec.describe Ui::ButtonGroup::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new) { "Buttons" }

    expect(page).to have_css("div[role='group']")
    expect(page).to have_text("Buttons")
  end

  it "accepts custom classes" do
    render_inline(described_class.new(class: "my-custom")) { "Buttons" }

    expect(page).to have_css("div.my-custom")
  end
end
