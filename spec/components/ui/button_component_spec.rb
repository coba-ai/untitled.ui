require "rails_helper"

RSpec.describe Ui::Button::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new) { "Click me" }

    expect(page).to have_button("Click me")
  end

  it "renders all color variants" do
    %i[primary secondary tertiary link_gray link_color
       primary_destructive secondary_destructive tertiary_destructive link_destructive].each do |color|
      render_inline(described_class.new(color: color)) { "Button" }
      expect(page).to have_text("Button")
    end
  end

  it "renders all size variants" do
    %i[sm md lg xl].each do |size|
      render_inline(described_class.new(size: size)) { "Button" }
      expect(page).to have_text("Button")
    end
  end

  it "renders as a link when href is provided" do
    render_inline(described_class.new(href: "/test")) { "Link" }

    expect(page).to have_link("Link", href: "/test")
  end

  it "renders disabled state" do
    render_inline(described_class.new(disabled: true)) { "Disabled" }

    expect(page).to have_button("Disabled", disabled: true)
  end

  it "renders loading state" do
    render_inline(described_class.new(loading: true)) { "Loading" }

    expect(page).to have_css("[data-loading]")
  end
end
