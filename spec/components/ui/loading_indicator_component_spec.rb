require "rails_helper"

RSpec.describe Ui::LoadingIndicator::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new)

    expect(page).to have_css("svg")
  end

  it "renders line_spinner type" do
    render_inline(described_class.new(type: :line_spinner))

    expect(page).to have_css("svg")
  end

  it "renders with label" do
    render_inline(described_class.new(label: "Loading..."))

    expect(page).to have_text("Loading...")
  end

  it "renders all size variants" do
    %i[sm md lg xl].each do |size|
      render_inline(described_class.new(size: size))
      expect(page).to have_css("svg")
    end
  end
end
