# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::Accordion::Component, type: :component do
  it "renders with items" do
    render_inline(described_class.new) do |accordion|
      accordion.with_item(title: "First item") { "First content" }
      accordion.with_item(title: "Second item") { "Second content" }
    end

    expect(page).to have_text("First item")
    expect(page).to have_text("Second item")
    expect(page).to have_text("First content")
    expect(page).to have_text("Second content")
  end

  it "renders item titles as buttons" do
    render_inline(described_class.new) do |accordion|
      accordion.with_item(title: "Clickable Header") { "Content" }
    end

    expect(page).to have_button("Clickable Header")
  end

  it "sets aria-expanded to false by default" do
    render_inline(described_class.new) do |accordion|
      accordion.with_item(title: "Closed Item") { "Content" }
    end

    expect(page).to have_css("button[aria-expanded='false']")
  end

  it "sets aria-expanded to true when open: true" do
    render_inline(described_class.new) do |accordion|
      accordion.with_item(title: "Open Item", open: true) { "Content" }
    end

    expect(page).to have_css("button[aria-expanded='true']")
  end

  it "renders the stimulus data controller attribute" do
    render_inline(described_class.new) do |accordion|
      accordion.with_item(title: "Item") { "Content" }
    end

    expect(page).to have_css("[data-controller='accordion']")
  end

  it "passes multiple value to the data attribute" do
    render_inline(described_class.new(multiple: true)) do |accordion|
      accordion.with_item(title: "Item") { "Content" }
    end

    expect(page).to have_css("[data-accordion-multiple-value='true']")
  end

  it "defaults multiple to false" do
    render_inline(described_class.new) do |accordion|
      accordion.with_item(title: "Item") { "Content" }
    end

    expect(page).to have_css("[data-accordion-multiple-value='false']")
  end

  it "renders a chevron svg for each item" do
    render_inline(described_class.new) do |accordion|
      accordion.with_item(title: "Item 1") { "Content 1" }
      accordion.with_item(title: "Item 2") { "Content 2" }
    end

    expect(page).to have_css("[data-accordion-target='chevron']", count: 2)
  end

  it "accepts a custom class" do
    render_inline(described_class.new(class: "my-custom-class")) do |accordion|
      accordion.with_item(title: "Item") { "Content" }
    end

    expect(page).to have_css(".my-custom-class")
  end

  it "renders item with an icon" do
    icon_svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/></svg>'

    render_inline(described_class.new) do |accordion|
      accordion.with_item(title: "Icon Item", icon: icon_svg) { "Content" }
    end

    expect(page).to have_text("Icon Item")
    expect(page).to have_css("svg", minimum: 2)
  end

  it "renders multiple items" do
    render_inline(described_class.new) do |accordion|
      accordion.with_item(title: "First") { "Content A" }
      accordion.with_item(title: "Second") { "Content B" }
      accordion.with_item(title: "Third") { "Content C" }
    end

    expect(page).to have_css(".accordion-item", count: 3)
  end

  it "opens item with open: true and collapsed item has height 0 style" do
    render_inline(described_class.new) do |accordion|
      accordion.with_item(title: "Closed") { "Closed content" }
      accordion.with_item(title: "Open", open: true) { "Open content" }
    end

    expect(page).to have_css("[data-accordion-target='panel'][style='height: 0;']")
    expect(page).to have_css("[data-accordion-target='panel'][style='']")
  end

  it "associates panel with header via aria attributes" do
    render_inline(described_class.new) do |accordion|
      accordion.with_item(title: "Aria Item") { "Content" }
    end

    header = page.find("button[data-accordion-target='header']")
    header_id = header["id"]
    panel = page.find("[data-accordion-target='panel']")

    expect(header_id).to match(/accordion-header-/)
    expect(panel["aria-labelledby"]).to eq(header_id)
    expect(header["aria-controls"]).to eq(panel["id"])
  end
end
