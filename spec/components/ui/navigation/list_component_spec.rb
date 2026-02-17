require "rails_helper"

RSpec.describe Ui::Navigation::List::Component, type: :component do
  let(:icon_svg) { '<svg class="size-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path d="M12 6v12" /></svg>' }

  it "renders items as links" do
    items = [
      { label: "Dashboard", href: "/dashboard", icon: icon_svg },
      { label: "Projects", href: "/projects", icon: icon_svg }
    ]
    render_inline(described_class.new(items: items))

    expect(page).to have_link("Dashboard", href: "/dashboard")
    expect(page).to have_link("Projects", href: "/projects")
  end

  it "renders dividers" do
    items = [
      { label: "Dashboard", href: "/dashboard" },
      { divider: true },
      { label: "Settings", href: "/settings" }
    ]
    render_inline(described_class.new(items: items))

    expect(page).to have_css("hr")
  end

  it "renders collapsible items with sub-items" do
    items = [
      {
        label: "Settings",
        icon: icon_svg,
        items: [
          { label: "Profile", href: "/settings/profile" },
          { label: "Security", href: "/settings/security" }
        ]
      }
    ]
    render_inline(described_class.new(items: items))

    expect(page).to have_css("details")
    expect(page).to have_css("summary")
    expect(page).to have_text("Profile")
    expect(page).to have_text("Security")
  end

  it "marks active item by URL" do
    items = [
      { label: "Dashboard", href: "/dashboard" },
      { label: "Projects", href: "/projects" }
    ]
    render_inline(described_class.new(items: items, active_url: "/projects"))

    expect(page).to have_css("a[aria-current='page']", text: "Projects")
  end

  it "opens collapsible when child is active" do
    items = [
      {
        label: "Settings",
        items: [
          { label: "Profile", href: "/settings/profile" }
        ]
      }
    ]
    render_inline(described_class.new(items: items, active_url: "/settings/profile"))

    expect(page).to have_css("details[open]")
  end
end
