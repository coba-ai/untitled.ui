require "rails_helper"

RSpec.describe Ui::Table::Component, type: :component do
  it "renders with columns" do
    render_inline(described_class.new) do |table|
      table.with_column(label: "Name")
      table.with_column(label: "Email")
      "<tr><td>Test</td><td>test@test.com</td></tr>".html_safe
    end

    expect(page).to have_css("table")
    expect(page).to have_text("Name")
    expect(page).to have_text("Email")
  end

  it "renders sortable columns" do
    render_inline(described_class.new) do |table|
      table.with_header_content { "<div>Header</div>".html_safe }
      table.with_column(label: "Name", sortable: true)
      ""
    end

    expect(page).to have_text("Name")
  end
end
