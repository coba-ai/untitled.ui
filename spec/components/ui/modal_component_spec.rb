require "rails_helper"

RSpec.describe Ui::Modal::Component, type: :component do
  it "renders with trigger and content" do
    render_inline(described_class.new) do |modal|
      modal.with_trigger { "Open" }
      "Modal content"
    end

    expect(page).to have_text("Open")
    expect(page).to have_css("dialog")
  end

  it "renders header and footer slots" do
    render_inline(described_class.new) do |modal|
      modal.with_trigger { "Open" }
      modal.with_header { "Title" }
      modal.with_footer { "Footer" }
      "Body"
    end

    expect(page).to have_text("Title")
    expect(page).to have_text("Footer")
  end
end
