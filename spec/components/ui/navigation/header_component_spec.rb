require "rails_helper"

RSpec.describe Ui::Navigation::Header::Component, type: :component do
  let(:items) do
    [
      { label: "Dashboard", href: "/dashboard" },
      { label: "Projects", href: "/projects" }
    ]
  end

  it "renders header with navigation items" do
    render_inline(described_class.new(items: items))

    expect(page).to have_css("header")
    expect(page).to have_text("Dashboard")
    expect(page).to have_text("Projects")
  end

  it "renders logo slot" do
    render_inline(described_class.new(items: items)) do |header|
      header.with_logo { "<span>Logo</span>".html_safe }
    end

    expect(page).to have_text("Logo")
  end

  it "renders trailing content slot" do
    render_inline(described_class.new(items: items)) do |header|
      header.with_trailing_content { "<span>Search</span>".html_safe }
    end

    expect(page).to have_text("Search")
  end

  it "renders secondary nav bar when sub_items provided" do
    sub_items = [
      { label: "Overview", href: "/dashboard/overview" },
      { label: "Analytics", href: "/dashboard/analytics" }
    ]
    render_inline(described_class.new(items: items, sub_items: sub_items))

    expect(page).to have_text("Overview")
    expect(page).to have_text("Analytics")
  end

  it "renders secondary nav from active item sub-items" do
    items_with_subs = [
      {
        label: "Dashboard", href: "/dashboard",
        items: [
          { label: "Overview", href: "/dashboard/overview" },
          { label: "Reports", href: "/dashboard/reports" }
        ]
      }
    ]
    render_inline(described_class.new(items: items_with_subs, active_url: "/dashboard"))

    expect(page).to have_text("Overview")
    expect(page).to have_text("Reports")
  end

  it "renders mobile header" do
    render_inline(described_class.new(items: items))

    expect(page).to have_css("[data-controller='navigation-mobile']")
  end

  it "hides border when hide_border is true" do
    component = described_class.new(items: items, hide_border: true)
    expect(component.header_classes).not_to include("border-b")
  end
end
