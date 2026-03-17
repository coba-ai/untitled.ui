# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::CommandPalette::Component, type: :component do
  let(:sample_items) do
    [
      { label: "Dashboard", value: "dashboard", group: "Navigation" },
      { label: "Settings", value: "settings", group: "Navigation" },
      { label: "New Project", value: "new_project", group: "Actions" },
      { label: "Export Data", value: "export", group: "Actions" }
    ]
  end

  it "renders with default props" do
    render_inline(described_class.new(items: sample_items))

    expect(page).to have_css("[data-controller='command-palette']")
    expect(page).to have_css("dialog")
  end

  it "renders the search input with default placeholder" do
    render_inline(described_class.new(items: sample_items))

    expect(page).to have_css("input[placeholder='Type a command or search...']")
  end

  it "renders with a custom placeholder" do
    render_inline(described_class.new(items: sample_items, placeholder: "Search commands..."))

    expect(page).to have_css("input[placeholder='Search commands...']")
  end

  it "renders all item labels" do
    render_inline(described_class.new(items: sample_items))

    expect(page).to have_text("Dashboard")
    expect(page).to have_text("Settings")
    expect(page).to have_text("New Project")
    expect(page).to have_text("Export Data")
  end

  it "renders group headers" do
    render_inline(described_class.new(items: sample_items))

    expect(page).to have_text("Navigation")
    expect(page).to have_text("Actions")
  end

  it "renders items with correct data attributes" do
    render_inline(described_class.new(items: sample_items))

    expect(page).to have_css("[data-value='dashboard']")
    expect(page).to have_css("[data-value='settings']")
    expect(page).to have_css("[data-value='new_project']")
  end

  it "renders items as option roles" do
    render_inline(described_class.new(items: sample_items))

    expect(page).to have_css("[role='option']", count: sample_items.size)
  end

  it "renders with a custom id" do
    render_inline(described_class.new(items: sample_items, id: "my-palette"))

    expect(page).to have_css("dialog#my-palette")
  end

  it "renders items with icons when provided" do
    items_with_icons = [
      { label: "Dashboard", value: "dashboard", group: "Nav",
        icon: '<svg class="test-icon" viewBox="0 0 24 24"><path d="M3 12h18"/></svg>' }
    ]
    render_inline(described_class.new(items: items_with_icons))

    expect(page).to have_css("svg.test-icon")
  end

  it "renders the empty state element" do
    render_inline(described_class.new(items: sample_items))

    expect(page).to have_css("[data-command-palette-target='emptyState']")
    expect(page).to have_text("No results found.")
  end

  it "renders keyboard navigation hints in footer" do
    render_inline(described_class.new(items: sample_items))

    expect(page).to have_text("Navigate")
    expect(page).to have_text("Select")
    expect(page).to have_text("Close")
  end

  it "renders with items that have no group" do
    ungrouped_items = [
      { label: "Home", value: "home" },
      { label: "About", value: "about" }
    ]
    render_inline(described_class.new(items: ungrouped_items))

    expect(page).to have_text("Home")
    expect(page).to have_text("About")
  end

  it "renders with correct stimulus data attributes for items value" do
    render_inline(described_class.new(items: sample_items))

    expect(page).to have_css("[data-command-palette-items-value]")
  end

  it "accepts additional CSS classes" do
    render_inline(described_class.new(items: sample_items, class: "custom-class"))

    # The extra class is applied to the inner dialog container
    expect(page).to have_css(".custom-class")
  end

  it "renders combobox input with correct aria attributes" do
    render_inline(described_class.new(items: sample_items))

    expect(page).to have_css("input[role='combobox']")
    expect(page).to have_css("input[aria-expanded='true']")
  end
end
