require "rails_helper"

RSpec.describe Ui::Label::Component, type: :component do
  it "renders label text" do
    render_inline(described_class.new(text: "Email"))

    expect(page).to have_css("label")
    expect(page).to have_text("Email")
  end

  it "shows required asterisk when required" do
    render_inline(described_class.new(text: "Name", required: true))

    expect(page).to have_text("*")
  end

  it "renders tooltip when provided" do
    render_inline(described_class.new(text: "Field", tooltip: "Help text"))

    expect(page).to have_css("span[title='Help text']")
  end
end
