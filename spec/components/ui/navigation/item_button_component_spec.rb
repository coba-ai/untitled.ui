require "rails_helper"

RSpec.describe Ui::Navigation::ItemButton::Component, type: :component do
  let(:icon_svg) { '<svg class="size-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path d="M12 6v12" /></svg>' }

  it "renders with label and icon" do
    render_inline(described_class.new(label: "Settings", icon: icon_svg, href: "/settings"))

    expect(page).to have_css("a[aria-label='Settings']")
    expect(page).to have_css("a[href='/settings']")
  end

  it "renders wrapped in a tooltip" do
    render_inline(described_class.new(label: "Settings", icon: icon_svg))

    expect(page).to have_css("[role='tooltip']")
    expect(page).to have_text("Settings")
  end

  it "applies md size by default" do
    render_inline(described_class.new(label: "Settings", icon: icon_svg))

    expect(page).to have_css("a.size-10")
  end

  it "applies lg size" do
    render_inline(described_class.new(label: "Settings", icon: icon_svg, size: :lg))

    expect(page).to have_css("a.size-12")
  end

  it "applies active styles when current" do
    render_inline(described_class.new(label: "Settings", icon: icon_svg, current: true))

    expect(page).to have_css("a.bg-active")
  end
end
