# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::Drawer::Component, type: :component do
  it "renders with trigger and content" do
    render_inline(described_class.new) do |drawer|
      drawer.with_trigger { "Open Drawer" }
      "Drawer body content"
    end

    expect(page).to have_text("Open Drawer")
    expect(page).to have_css("dialog")
  end

  it "renders header and footer slots" do
    render_inline(described_class.new) do |drawer|
      drawer.with_trigger { "Open" }
      drawer.with_header { "Drawer Title" }
      drawer.with_footer { "Footer Actions" }
      "Body"
    end

    expect(page).to have_text("Drawer Title")
    expect(page).to have_text("Footer Actions")
  end

  it "renders close button when header is present" do
    render_inline(described_class.new) do |drawer|
      drawer.with_header { "Title" }
      "Content"
    end

    expect(page).to have_css("button[aria-label='Close drawer']")
  end

  it "defaults to right position" do
    render_inline(described_class.new)

    expect(page).to have_css("dialog.justify-end")
  end

  it "renders left position" do
    render_inline(described_class.new(position: :left))

    expect(page).to have_css("dialog.justify-start")
  end

  it "renders sm size" do
    render_inline(described_class.new(size: :sm)) do |drawer|
      drawer.with_header { "Small Drawer" }
      "Content"
    end

    expect(page).to have_css(".w-80")
  end

  it "renders lg size" do
    render_inline(described_class.new(size: :lg)) do |drawer|
      drawer.with_header { "Large Drawer" }
      "Content"
    end

    expect(page).to have_css(".w-\\[32rem\\]")
  end

  it "uses provided id" do
    render_inline(described_class.new(id: "my-drawer"))

    expect(page).to have_css("dialog#my-drawer")
  end

  it "generates a random id when none provided" do
    render_inline(described_class.new)

    expect(page).to have_css("dialog[id^='drawer-']")
  end

  it "applies extra classes to panel" do
    render_inline(described_class.new(class: "custom-class"))

    expect(page).to have_css(".custom-class")
  end

  it "renders without trigger" do
    render_inline(described_class.new) { "Content only" }

    expect(page).to have_text("Content only")
    expect(page).to have_css("dialog")
  end

  it "sets stimulus controller on root element" do
    render_inline(described_class.new)

    expect(page).to have_css("[data-controller='drawer']")
  end
end
