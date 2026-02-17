require "rails_helper"

RSpec.describe Ui::RadioButton::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new)

    expect(page).to have_css("input[type='radio']", visible: :all)
  end

  it "renders with label" do
    render_inline(described_class.new(label: "Option A"))

    expect(page).to have_text("Option A")
  end

  it "renders with hint" do
    render_inline(described_class.new(label: "Option", hint: "Description"))

    expect(page).to have_text("Description")
  end

  it "renders checked state" do
    render_inline(described_class.new(checked: true))

    expect(page).to have_css("input[checked]", visible: :all)
  end

  it "renders disabled state" do
    render_inline(described_class.new(disabled: true))

    expect(page).to have_css("input[disabled]", visible: :all)
  end
end
