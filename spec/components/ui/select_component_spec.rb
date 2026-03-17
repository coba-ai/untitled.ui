# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::Select::Component, type: :component do
  let(:options) { [["Apple", "apple"], ["Banana", "banana"], ["Cherry", "cherry"]] }

  it "renders with default props" do
    render_inline(described_class.new(options: options))

    expect(page).to have_css("[data-controller='select']")
    expect(page).to have_css("[role='combobox']")
    expect(page).to have_css("[role='listbox']")
  end

  it "renders placeholder text" do
    render_inline(described_class.new(options: options, placeholder: "Pick a fruit"))

    expect(page).to have_text("Pick a fruit")
  end

  it "renders all options" do
    render_inline(described_class.new(options: options))

    expect(page).to have_css("[role='option']", count: 3)
    expect(page).to have_text("Apple")
    expect(page).to have_text("Banana")
    expect(page).to have_text("Cherry")
  end

  it "renders with a selected value" do
    render_inline(described_class.new(options: options, value: "banana"))

    expect(page).to have_text("Banana")
    expect(page).to have_css("[aria-selected='true'][data-value='banana']")
  end

  it "renders with label" do
    render_inline(described_class.new(options: options, label: "Fruit"))

    expect(page).to have_text("Fruit")
  end

  it "renders with hint" do
    render_inline(described_class.new(options: options, hint: "Choose your favorite"))

    expect(page).to have_text("Choose your favorite")
  end

  it "renders invalid state" do
    render_inline(described_class.new(options: options, invalid: true, hint: "Required field"))

    expect(page).to have_text("Required field")
  end

  it "renders disabled state" do
    render_inline(described_class.new(options: options, disabled: true))

    expect(page).to have_css("[aria-disabled='true']")
    expect(page).to have_css("[tabindex='-1']")
  end

  it "renders hidden input with name and value" do
    render_inline(described_class.new(options: options, name: "fruit", value: "apple"))

    expect(page).to have_css("input[type='hidden'][name='fruit'][value='apple']", visible: :hidden)
  end

  it "renders required hidden input" do
    render_inline(described_class.new(options: options, name: "fruit", required: true))

    expect(page).to have_css("input[type='hidden'][required]", visible: :hidden)
  end

  it "renders search input when searchable" do
    render_inline(described_class.new(options: options, searchable: true))

    expect(page).to have_css("input[type='text'][placeholder='Search...']", visible: :all)
  end

  it "does not render search input when not searchable" do
    render_inline(described_class.new(options: options, searchable: false))

    expect(page).not_to have_css("input[type='text'][placeholder='Search...']", visible: :all)
  end

  it "accepts hash options" do
    hash_options = [{ label: "Red", value: "red" }, { label: "Blue", value: "blue" }]
    render_inline(described_class.new(options: hash_options))

    expect(page).to have_css("[role='option']", count: 2)
    expect(page).to have_text("Red")
    expect(page).to have_text("Blue")
  end

  it "renders with id" do
    render_inline(described_class.new(options: options, id: "my-select", name: "fruit"))

    expect(page).to have_css("input[type='hidden'][id='my-select']", visible: :hidden)
  end

  context "sizes" do
    it "renders small size" do
      render_inline(described_class.new(options: options, size: :sm))

      expect(page).to have_css("[role='combobox']")
    end

    it "renders medium size" do
      render_inline(described_class.new(options: options, size: :md))

      expect(page).to have_css("[role='combobox']")
    end
  end
end
