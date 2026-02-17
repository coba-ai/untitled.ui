require "rails_helper"

RSpec.describe Ui::Toggle::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new)

    expect(page).to have_css("[data-controller='toggle']")
  end

  it "renders with label" do
    render_inline(described_class.new(label: "Notifications"))

    expect(page).to have_text("Notifications")
  end

  it "renders with hint" do
    render_inline(described_class.new(label: "Toggle", hint: "Enable this"))

    expect(page).to have_text("Enable this")
  end
end
