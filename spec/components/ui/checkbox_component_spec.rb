require "rails_helper"

RSpec.describe Ui::Checkbox::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new)

    expect(page).to have_css("input[type='checkbox']")
  end

  it "renders with label" do
    render_inline(described_class.new(label: "Accept terms"))

    expect(page).to have_text("Accept terms")
  end

  it "renders checked state" do
    render_inline(described_class.new(checked: true))

    expect(page).to have_css("input[type='checkbox']")
  end

  it "renders disabled state" do
    render_inline(described_class.new(disabled: true))

    expect(page).to have_css("input[disabled]")
  end
end
