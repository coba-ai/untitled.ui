require "rails_helper"

RSpec.describe Ui::Badge::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new) { "Badge" }

    expect(page).to have_text("Badge")
  end

  it "renders all color variants" do
    %i[gray brand error warning success blue indigo purple pink orange].each do |color|
      render_inline(described_class.new(color: color)) { color.to_s }
      expect(page).to have_text(color.to_s)
    end
  end

  it "renders all type variants" do
    %i[pill_color badge_color badge_modern].each do |type|
      render_inline(described_class.new(type: type)) { "Badge" }
      expect(page).to have_text("Badge")
    end
  end

  it "renders all sizes" do
    %i[sm md lg].each do |size|
      render_inline(described_class.new(size: size)) { "Badge" }
      expect(page).to have_text("Badge")
    end
  end
end
