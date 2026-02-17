require "rails_helper"

RSpec.describe Ui::Textarea::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new)

    expect(page).to have_css("textarea")
  end

  it "renders with label" do
    render_inline(described_class.new(label: "Description"))

    expect(page).to have_text("Description")
  end

  it "renders with placeholder" do
    render_inline(described_class.new(placeholder: "Enter text..."))

    expect(page).to have_css("textarea[placeholder='Enter text...']")
  end

  it "renders with hint" do
    render_inline(described_class.new(label: "Bio", hint: "Max 500 chars"))

    expect(page).to have_text("Bio")
    expect(page).to have_css("textarea")
  end

  it "renders disabled state" do
    render_inline(described_class.new(disabled: true))

    expect(page).to have_css("textarea[disabled]")
  end

  it "renders with custom rows" do
    render_inline(described_class.new(rows: 8))

    expect(page).to have_css("textarea[rows='8']")
  end
end
