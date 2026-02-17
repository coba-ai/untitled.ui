require "rails_helper"

RSpec.describe Ui::Dropdown::Component, type: :component do
  it "renders with trigger and items" do
    render_inline(described_class.new) do |dropdown|
      dropdown.with_trigger { "Menu" }
      dropdown.with_item(label: "Edit")
      dropdown.with_item(label: "Delete")
    end

    expect(page).to have_text("Menu")
    expect(page).to have_text("Edit")
    expect(page).to have_text("Delete")
  end
end
