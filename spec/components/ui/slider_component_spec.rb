# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::Slider::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new)

    expect(page).to have_css("[data-controller='slider']")
    expect(page).to have_css("input[type='range']")
  end

  it "renders with a label" do
    render_inline(described_class.new(label: "Volume"))

    expect(page).to have_text("Volume")
  end

  it "renders with a custom value" do
    render_inline(described_class.new(value: 75))

    expect(page).to have_css("input[type='range'][value='75']")
  end

  it "renders with min and max" do
    render_inline(described_class.new(min: 10, max: 200))

    expect(page).to have_css("input[type='range'][min='10'][max='200']")
  end

  it "renders with step" do
    render_inline(described_class.new(step: 5))

    expect(page).to have_css("input[type='range'][step='5']")
  end

  it "shows value display by default" do
    render_inline(described_class.new(value: 60))

    expect(page).to have_css("[data-slider-target='valueDisplay']")
    expect(page).to have_text("60")
  end

  it "hides value display when show_value is false" do
    render_inline(described_class.new(value: 60, show_value: false))

    expect(page).not_to have_css("[data-slider-target='valueDisplay']")
  end

  it "renders hidden input for form submission when name is given" do
    render_inline(described_class.new(name: "volume", value: 40))

    expect(page).to have_css("input[type='hidden'][name='volume'][value='40']", visible: :hidden)
  end

  it "renders disabled state" do
    render_inline(described_class.new(disabled: true))

    expect(page).to have_css("input[type='range'][disabled]")
  end

  it "renders with a custom id" do
    render_inline(described_class.new(id: "my-slider", label: "Level"))

    expect(page).to have_css("input[type='range']#my-slider")
    expect(page).to have_css("label[for='my-slider']")
  end

  it "calculates percentage correctly" do
    component = described_class.new(value: 50, min: 0, max: 100)
    expect(component.percentage).to eq(50.0)
  end

  it "calculates percentage at min" do
    component = described_class.new(value: 0, min: 0, max: 100)
    expect(component.percentage).to eq(0.0)
  end

  it "calculates percentage at max" do
    component = described_class.new(value: 100, min: 0, max: 100)
    expect(component.percentage).to eq(100.0)
  end

  it "renders fill element with correct initial width" do
    render_inline(described_class.new(value: 25, min: 0, max: 100))

    expect(page).to have_css("[data-slider-target='fill']")
  end
end
