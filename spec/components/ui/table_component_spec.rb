# frozen_string_literal: true

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

  # Row selection tests

  describe "selectable option" do
    it "does not render checkboxes by default" do
      render_inline(described_class.new) do |table|
        table.with_column(label: "Name")
        "<tr><td>Alice</td></tr>".html_safe
      end

      expect(page).not_to have_css("input[type='checkbox']")
    end

    it "renders a select-all checkbox in the header when selectable: true" do
      render_inline(described_class.new(selectable: true)) do |table|
        table.with_column(label: "Name")
        "<tr><td>Alice</td></tr>".html_safe
      end

      expect(page).to have_css("thead input[type='checkbox'][data-table-target='selectAll']")
    end

    it "attaches the stimulus controller when selectable: true" do
      render_inline(described_class.new(selectable: true)) do |table|
        table.with_column(label: "Name")
        ""
      end

      expect(page).to have_css("[data-controller='table']")
    end

    it "renders row checkboxes for each data row" do
      render_inline(described_class.new(selectable: true)) do |table|
        table.with_column(label: "Name")
        <<~HTML.html_safe
          <tr>
            <td><input type="checkbox" data-table-target="rowCheckbox" data-action="change->table#toggleRow" /></td>
            <td>Alice</td>
          </tr>
          <tr>
            <td><input type="checkbox" data-table-target="rowCheckbox" data-action="change->table#toggleRow" /></td>
            <td>Bob</td>
          </tr>
        HTML
      end

      expect(page).to have_css("input[data-table-target='rowCheckbox']", count: 2)
    end

    it "renders the bulk_actions slot hidden by default" do
      render_inline(described_class.new(selectable: true)) do |table|
        table.with_column(label: "Name")
        table.with_bulk_actions { "<button>Delete selected</button>".html_safe }
        ""
      end

      expect(page).to have_css("[data-table-target='bulkActions'].hidden")
      expect(page).to have_text("Delete selected")
    end
  end

  # Sortable column tests

  describe "sortable option" do
    it "does not render sort buttons by default" do
      render_inline(described_class.new) do |table|
        table.with_column(label: "Name")
        ""
      end

      expect(page).not_to have_css("button[data-action='click->table#sort']")
    end

    it "renders sort buttons on columns when sortable: true on the table" do
      render_inline(described_class.new(sortable: true)) do |table|
        table.with_column(label: "Name")
        table.with_column(label: "Email")
        ""
      end

      expect(page).to have_css("button[data-action='click->table#sort']", count: 2)
      expect(page).to have_css("[data-table-target='sortButton']", count: 2)
    end

    it "renders sort button only on columns marked sortable: true" do
      render_inline(described_class.new) do |table|
        table.with_column(label: "Name", sortable: true)
        table.with_column(label: "Email")
        ""
      end

      expect(page).to have_css("button[data-action='click->table#sort']", count: 1)
    end

    it "attaches the stimulus controller when sortable: true" do
      render_inline(described_class.new(sortable: true)) do |table|
        table.with_column(label: "Name")
        ""
      end

      expect(page).to have_css("[data-controller='table']")
    end

    it "sets aria-sort='none' on sort buttons initially" do
      render_inline(described_class.new(sortable: true)) do |table|
        table.with_column(label: "Name")
        ""
      end

      expect(page).to have_css("button[aria-sort='none']")
    end

    it "includes the correct column index on each sort button" do
      render_inline(described_class.new(sortable: true)) do |table|
        table.with_column(label: "Name")
        table.with_column(label: "Email")
        ""
      end

      expect(page).to have_css("button[data-column='0']")
      expect(page).to have_css("button[data-column='1']")
    end

    it "offsets column index when selectable: true" do
      render_inline(described_class.new(selectable: true, sortable: true)) do |table|
        table.with_column(label: "Name")
        table.with_column(label: "Email")
        ""
      end

      # With selectable, the first data column in <td> is at index 1
      expect(page).to have_css("button[data-column='1']")
      expect(page).to have_css("button[data-column='2']")
    end

    it "renders ascending and descending sort icons (initially hidden)" do
      render_inline(described_class.new(sortable: true)) do |table|
        table.with_column(label: "Name")
        ""
      end

      expect(page).to have_css("svg[data-sort-asc].hidden")
      expect(page).to have_css("svg[data-sort-desc].hidden")
      expect(page).to have_css("svg[data-sort-default]")
    end
  end

  # Combined selectable + sortable

  describe "selectable and sortable combined" do
    it "renders both the select-all checkbox and sort buttons" do
      render_inline(described_class.new(selectable: true, sortable: true)) do |table|
        table.with_column(label: "Name")
        ""
      end

      expect(page).to have_css("input[data-table-target='selectAll']")
      expect(page).to have_css("button[data-action='click->table#sort']")
      expect(page).to have_css("[data-controller='table']")
    end
  end

  # bulk_actions slot

  describe "bulk_actions slot" do
    it "renders without bulk_actions by default" do
      render_inline(described_class.new) do |table|
        table.with_column(label: "Name")
        ""
      end

      expect(page).not_to have_css("[data-table-target='bulkActions']")
    end

    it "renders bulk_actions content when provided" do
      render_inline(described_class.new(selectable: true)) do |table|
        table.with_column(label: "Name")
        table.with_bulk_actions { "<button>Archive</button>".html_safe }
        ""
      end

      expect(page).to have_text("Archive")
      expect(page).to have_css("[data-table-target='bulkActions']")
    end
  end

  # Backward compatibility

  describe "backward compatibility" do
    it "still renders with just columns and rows (no new props)" do
      render_inline(described_class.new) do |table|
        table.with_column(label: "Name")
        table.with_column(label: "Status")
        "<tr><td>Alice</td><td>Active</td></tr>".html_safe
      end

      expect(page).to have_css("table")
      expect(page).to have_text("Name")
      expect(page).to have_text("Status")
      expect(page).to have_text("Alice")
      expect(page).not_to have_css("[data-controller='table']")
    end

    it "still renders with header_content slot" do
      render_inline(described_class.new) do |table|
        table.with_header_content { "<h3>My Table</h3>".html_safe }
        table.with_column(label: "Name")
        ""
      end

      expect(page).to have_text("My Table")
      expect(page).to have_css("table")
    end

    it "still renders small size" do
      render_inline(described_class.new(size: :sm)) do |table|
        table.with_column(label: "Name")
        ""
      end

      expect(page).to have_css("table")
      expect(page).to have_text("Name")
    end
  end
end
