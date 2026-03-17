# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::ColorPicker::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new)

    expect(page).to have_css("input[type='text'][readonly]")
    expect(page).to have_css("input[type='hidden']", visible: false)
  end

  it "renders default color value #000000" do
    render_inline(described_class.new)

    expect(page).to have_css("input[type='text'][value='#000000']")
    expect(page).to have_css("input[type='hidden'][value='#000000']", visible: false)
  end

  it "renders with a custom hex value" do
    render_inline(described_class.new(value: "#FF5733"))

    expect(page).to have_css("input[type='text'][value='#FF5733']")
    expect(page).to have_css("input[type='hidden'][value='#FF5733']", visible: false)
  end

  it "renders with a label" do
    render_inline(described_class.new(label: "Brand Color", name: "brand_color"))

    expect(page).to have_text("Brand Color")
    expect(page).to have_css("input[type='hidden'][name='brand_color']", visible: false)
  end

  it "renders with a hint" do
    render_inline(described_class.new(label: "Color", hint: "Choose your brand color"))

    expect(page).to have_text("Choose your brand color")
  end

  it "renders hidden input with name" do
    render_inline(described_class.new(name: "accent_color"))

    expect(page).to have_css("input[type='hidden'][name='accent_color']", visible: false)
    expect(page).not_to have_css("input[type='text'][name='accent_color']")
  end

  it "renders with an id on the display input" do
    render_inline(described_class.new(id: "color-input"))

    expect(page).to have_css("input[type='text'][id='color-input']")
  end

  it "renders with required on the hidden input" do
    render_inline(described_class.new(required: true, name: "color"))

    expect(page).to have_css("input[type='hidden'][required]", visible: false)
  end

  it "renders default swatches" do
    render_inline(described_class.new)

    expect(page).to have_css("[data-color-picker-target='swatchButton']")
  end

  it "renders custom swatches" do
    render_inline(described_class.new(swatches: ["#FF0000", "#00FF00", "#0000FF"]))

    expect(page).to have_css("[data-color='#FF0000']")
    expect(page).to have_css("[data-color='#00FF00']")
    expect(page).to have_css("[data-color='#0000FF']")
  end

  it "renders the hex input field" do
    render_inline(described_class.new)

    expect(page).to have_css("[data-color-picker-target='hexInput']")
  end

  it "renders invalid state" do
    render_inline(described_class.new(invalid: true, hint: "A color is required"))

    expect(page).to have_text("A color is required")
    expect(page).to have_css("div.ring-error_subtle")
  end

  it "renders disabled state without Stimulus controller" do
    render_inline(described_class.new(disabled: true))

    expect(page).to have_css("input[type='text'][disabled]")
    expect(page).not_to have_css("[data-controller='color-picker']")
  end

  it "attaches Stimulus controller when not disabled" do
    render_inline(described_class.new)

    expect(page).to have_css("[data-controller='color-picker']")
  end

  it "renders the dropdown panel" do
    render_inline(described_class.new)

    expect(page).to have_css("[data-color-picker-target='panel']")
  end

  it "renders the color swatch preview in trigger" do
    render_inline(described_class.new(value: "#3B82F6"))

    expect(page).to have_css("[data-color-picker-target='swatch']")
  end

  it "renders with no swatches when empty array provided" do
    render_inline(described_class.new(swatches: []))

    expect(page).not_to have_css("[data-color-picker-target='swatchButton']")
  end

  it "normalizes value without leading hash" do
    render_inline(described_class.new(value: "FF5733"))

    expect(page).to have_css("input[type='text'][value='#FF5733']")
  end

  it "sets stimulus value attribute" do
    render_inline(described_class.new(value: "#22C55E"))

    expect(page).to have_css("[data-color-picker-value-value='#22C55E']")
  end
end
