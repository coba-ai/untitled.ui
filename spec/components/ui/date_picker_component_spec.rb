# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::DatePicker::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new)

    expect(page).to have_css("input[type='text'][placeholder='Select date'][readonly]")
    expect(page).to have_css("input[type='hidden']", visible: false)
    expect(page).to have_css("svg") # calendar icon
  end

  it "renders with a label" do
    render_inline(described_class.new(label: "Start Date", name: "start_date"))

    expect(page).to have_text("Start Date")
    expect(page).to have_css("input[type='hidden'][name='start_date']", visible: false)
  end

  it "renders with a hint" do
    render_inline(described_class.new(label: "Date", hint: "Choose a date"))

    expect(page).to have_text("Choose a date")
  end

  it "renders with a preset value" do
    render_inline(described_class.new(value: "2025-06-15", name: "date"))

    expect(page).to have_css("input[type='text'][value='2025-06-15']")
    expect(page).to have_css("input[type='hidden'][value='2025-06-15']", visible: false)
  end

  it "renders with a Date object value" do
    render_inline(described_class.new(value: Date.new(2025, 3, 10)))

    expect(page).to have_css("input[type='text'][value='2025-03-10']")
    expect(page).to have_css("input[type='hidden'][value='2025-03-10']", visible: false)
  end

  it "renders with custom format" do
    render_inline(described_class.new(value: "2025-06-15", format: "%d/%m/%Y"))

    expect(page).to have_css("input[type='text'][value='15/06/2025']")
  end

  it "renders invalid state" do
    render_inline(described_class.new(invalid: true, hint: "Date is required"))

    expect(page).to have_text("Date is required")
    expect(page).to have_css("div.ring-error_subtle")
  end

  it "renders disabled state" do
    render_inline(described_class.new(disabled: true))

    expect(page).to have_css("input[type='text'][disabled]")
    # Should not attach the Stimulus controller when disabled
    expect(page).not_to have_css("[data-controller='date-picker']")
  end

  it "renders required hidden input" do
    render_inline(described_class.new(required: true))

    expect(page).to have_css("input[type='hidden'][required]", visible: false)
  end

  it "renders with min and max constraints as data attributes" do
    render_inline(described_class.new(min: "2025-01-01", max: "2025-12-31"))

    expect(page).to have_css("[data-date-picker-min-value='2025-01-01']")
    expect(page).to have_css("[data-date-picker-max-value='2025-12-31']")
  end

  it "renders calendar panel with navigation and day headers" do
    render_inline(described_class.new)

    expect(page).to have_css("[data-date-picker-target='calendar']")
    expect(page).to have_css("[data-date-picker-target='monthYear']")
    expect(page).to have_css("[data-date-picker-target='days']")
    expect(page).to have_text("Su")
    expect(page).to have_text("Mo")
    expect(page).to have_text("Sa")
  end

  it "renders with custom placeholder" do
    render_inline(described_class.new(placeholder: "Pick a date"))

    expect(page).to have_css("input[placeholder='Pick a date']")
  end

  it "renders both size variants" do
    render_inline(described_class.new(size: :sm))
    expect(page).to have_css("input[type='text']")

    render_inline(described_class.new(size: :md))
    expect(page).to have_css("input[type='text']")
  end

  it "renders with an id" do
    render_inline(described_class.new(id: "my-date"))

    expect(page).to have_css("input[type='text'][id='my-date']")
  end

  it "renders with name on hidden input only" do
    render_inline(described_class.new(name: "event_date"))

    expect(page).to have_css("input[type='hidden'][name='event_date']", visible: false)
    expect(page).not_to have_css("input[type='text'][name='event_date']")
  end
end
