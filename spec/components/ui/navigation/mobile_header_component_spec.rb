require "rails_helper"

RSpec.describe Ui::Navigation::MobileHeader::Component, type: :component do
  it "renders header bar" do
    render_inline(described_class.new)

    expect(page).to have_css("header")
    expect(page).to have_css("button[aria-label='Expand navigation menu']")
  end

  it "renders logo slot" do
    render_inline(described_class.new) do |mobile|
      mobile.with_logo { "<span>Logo</span>".html_safe }
    end

    expect(page).to have_text("Logo")
  end

  it "renders overlay hidden by default" do
    render_inline(described_class.new) do |mobile|
      mobile.with_sidebar_content { "<nav>Sidebar</nav>".html_safe }
    end

    expect(page).to have_css("[data-navigation-mobile-target='overlay'].hidden")
    expect(page).to have_text("Sidebar")
  end

  it "uses navigation-mobile Stimulus controller" do
    render_inline(described_class.new)

    expect(page).to have_css("[data-controller='navigation-mobile']")
  end
end
