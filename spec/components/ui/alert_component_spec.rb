# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::Alert::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new(title: "Info", description: "Something happened."))

    expect(page).to have_css("[role='alert']")
    expect(page).to have_text("Info")
    expect(page).to have_text("Something happened.")
  end

  it "renders all variants" do
    %i[info success warning error].each do |variant|
      render_inline(described_class.new(title: variant.to_s, variant: variant))
      expect(page).to have_text(variant.to_s)
    end
  end

  it "renders title only" do
    render_inline(described_class.new(title: "Title only"))

    expect(page).to have_text("Title only")
  end

  it "renders description only" do
    render_inline(described_class.new(description: "Description only"))

    expect(page).to have_text("Description only")
  end

  it "renders the default icon for each variant" do
    %i[info success warning error].each do |variant|
      render_inline(described_class.new(title: "Test", variant: variant))
      expect(page).to have_css("svg")
    end
  end

  it "renders a custom icon when provided" do
    custom_icon = '<svg class="custom-icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/></svg>'
    render_inline(described_class.new(title: "Custom", icon: custom_icon))

    expect(page).to have_css("svg.custom-icon")
  end

  it "renders a close button when dismissible" do
    render_inline(described_class.new(title: "Dismiss me", dismissible: true))

    expect(page).to have_css("button[aria-label='Dismiss']")
  end

  it "does not render a close button by default" do
    render_inline(described_class.new(title: "No dismiss"))

    expect(page).to have_no_css("button[aria-label='Dismiss']")
  end

  it "accepts additional CSS classes" do
    render_inline(described_class.new(title: "Styled", class: "mt-4"))

    expect(page).to have_css("[role='alert'].mt-4")
  end
end
