# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::Breadcrumb::Component, type: :component do
  it "renders a breadcrumb nav with items" do
    render_inline(described_class.new) do |breadcrumb|
      breadcrumb.with_item(label: "Home", href: "/")
      breadcrumb.with_item(label: "Projects", href: "/projects")
      breadcrumb.with_item(label: "Current Project")
    end

    expect(page).to have_css("nav[aria-label='Breadcrumb']")
    expect(page).to have_css("ol")
    expect(page).to have_link("Home", href: "/")
    expect(page).to have_link("Projects", href: "/projects")
    expect(page).to have_text("Current Project")
  end

  it "marks the last item with aria-current='page'" do
    render_inline(described_class.new) do |breadcrumb|
      breadcrumb.with_item(label: "Home", href: "/")
      breadcrumb.with_item(label: "Dashboard")
    end

    expect(page).to have_css("span[aria-current='page']", text: "Dashboard")
  end

  it "does not render the last item as a link" do
    render_inline(described_class.new) do |breadcrumb|
      breadcrumb.with_item(label: "Home", href: "/")
      breadcrumb.with_item(label: "Settings")
    end

    expect(page).not_to have_link("Settings")
    expect(page).to have_text("Settings")
  end

  it "renders chevron separator by default" do
    render_inline(described_class.new) do |breadcrumb|
      breadcrumb.with_item(label: "Home", href: "/")
      breadcrumb.with_item(label: "Page")
    end

    expect(page).to have_css("span[aria-hidden='true'] svg")
  end

  it "renders slash separator" do
    render_inline(described_class.new(separator: :slash)) do |breadcrumb|
      breadcrumb.with_item(label: "Home", href: "/")
      breadcrumb.with_item(label: "Page")
    end

    expect(page).to have_css("span[aria-hidden='true'] svg")
  end

  it "renders items with icons" do
    home_icon = '<svg class="size-5" viewBox="0 0 24 24"><path d="M3 12l9-9 9 9"/></svg>'
    render_inline(described_class.new) do |breadcrumb|
      breadcrumb.with_item(label: "Home", href: "/", icon: home_icon)
      breadcrumb.with_item(label: "Page")
    end

    expect(page).to have_link("Home", href: "/")
    expect(page).to have_css("a svg")
  end

  it "marks a linked item as current when current: true" do
    render_inline(described_class.new) do |breadcrumb|
      breadcrumb.with_item(label: "Home", href: "/")
      breadcrumb.with_item(label: "Settings", href: "/settings", current: true)
    end

    expect(page).to have_css("a[href='/settings']")
    expect(page).to have_css("[aria-current='page']", text: "Settings")
  end

  it "accepts custom classes" do
    render_inline(described_class.new(class: "mt-4")) do |breadcrumb|
      breadcrumb.with_item(label: "Home", href: "/")
      breadcrumb.with_item(label: "Page")
    end

    expect(page).to have_css("nav.mt-4")
  end
end
