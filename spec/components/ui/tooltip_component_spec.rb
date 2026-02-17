require "rails_helper"

RSpec.describe Ui::Tooltip::Component, type: :component do
  it "renders with title" do
    render_inline(described_class.new(title: "Help")) do |c|
      c.with_trigger { "Hover me" }
    end

    expect(page).to have_text("Help")
    expect(page).to have_text("Hover me")
  end

  it "renders with description" do
    render_inline(described_class.new(title: "Title", description: "More info")) do |c|
      c.with_trigger { "Trigger" }
    end

    expect(page).to have_text("More info")
  end

  it "renders with tooltip role" do
    render_inline(described_class.new(title: "Tip")) do |c|
      c.with_trigger { "Hover" }
    end

    expect(page).to have_css("[role='tooltip']")
  end

  it "sets placement data attribute" do
    render_inline(described_class.new(title: "Tip", placement: :bottom)) do |c|
      c.with_trigger { "Hover" }
    end

    expect(page).to have_css("[data-tooltip-placement-value='bottom']")
  end
end
