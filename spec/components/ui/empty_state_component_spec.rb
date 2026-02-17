require "rails_helper"

RSpec.describe Ui::EmptyState::Component, type: :component do
  it "renders with title and description" do
    render_inline(described_class.new(title: "No items", description: "Nothing here"))

    expect(page).to have_text("No items")
    expect(page).to have_text("Nothing here")
  end

  it "renders all sizes" do
    %i[sm md lg].each do |size|
      render_inline(described_class.new(size: size, title: "Empty"))
      expect(page).to have_text("Empty")
    end
  end
end
