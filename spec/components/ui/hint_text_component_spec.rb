require "rails_helper"

RSpec.describe Ui::HintText::Component, type: :component do
  it "renders hint text" do
    render_inline(described_class.new) { "This is a hint" }

    expect(page).to have_text("This is a hint")
    expect(page).to have_css("p")
  end

  it "renders in normal state" do
    render_inline(described_class.new(invalid: false)) { "Hint" }

    expect(page).to have_css("p.text-tertiary")
  end

  it "renders in invalid state" do
    render_inline(described_class.new(invalid: true)) { "Error message" }

    expect(page).to have_css("p.text-error-primary")
  end
end
