require "rails_helper"

RSpec.describe Ui::Input::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new(placeholder: "Enter text"))

    expect(page).to have_css("input[placeholder='Enter text']")
  end

  it "renders with label" do
    render_inline(described_class.new(label: "Email", placeholder: "you@example.com"))

    expect(page).to have_text("Email")
    expect(page).to have_css("input")
  end

  it "renders with hint" do
    render_inline(described_class.new(label: "Email", hint: "Help text"))

    expect(page).to have_text("Email")
    expect(page).to have_css("input")
  end

  it "renders invalid state" do
    render_inline(described_class.new(invalid: true))

    expect(page).to have_css("svg") # error icon
  end

  it "renders disabled state" do
    render_inline(described_class.new(disabled: true))

    expect(page).to have_css("input[disabled]")
  end
end
