require "rails_helper"

RSpec.describe Ui::Pagination::Component, type: :component do
  describe "page number generation" do
    it "generates all pages when total is small" do
      component = described_class.new(current_page: 1, total_pages: 5)
      expect(component.pages.select { |p| p[:type] == :page }.map { |p| p[:value] }).to eq([1, 2, 3, 4, 5])
    end

    it "generates ellipsis for large page counts" do
      component = described_class.new(current_page: 5, total_pages: 20)
      types = component.pages.map { |p| p[:type] }
      expect(types).to include(:ellipsis)
    end

    it "shows first and last page with ellipsis in between" do
      component = described_class.new(current_page: 10, total_pages: 20)
      values = component.pages.select { |p| p[:type] == :page }.map { |p| p[:value] }
      expect(values).to include(1, 10, 20)
    end
  end

  describe "navigation urls" do
    it "generates default page urls" do
      component = described_class.new(current_page: 3, total_pages: 10)
      expect(component.page_url(5)).to eq("?page=5")
    end

    it "uses custom page_url proc" do
      component = described_class.new(current_page: 3, total_pages: 10, page_url: ->(p) { "/items?page=#{p}" })
      expect(component.page_url(5)).to eq("/items?page=5")
    end

    it "returns nil prev_url on first page" do
      component = described_class.new(current_page: 1, total_pages: 10)
      expect(component.prev_url).to be_nil
    end

    it "returns nil next_url on last page" do
      component = described_class.new(current_page: 10, total_pages: 10)
      expect(component.next_url).to be_nil
    end
  end

  describe "page_default type" do
    it "renders pagination nav" do
      render_inline(described_class.new(type: :page_default, current_page: 3, total_pages: 10))

      expect(page).to have_css("nav[aria-label='Pagination']")
      expect(page).to have_text("3")
    end

    it "renders prev and next buttons" do
      render_inline(described_class.new(type: :page_default, current_page: 3, total_pages: 10))

      expect(page).to have_text("Previous")
      expect(page).to have_text("Next")
    end

    it "marks current page" do
      render_inline(described_class.new(type: :page_default, current_page: 3, total_pages: 5))

      expect(page).to have_css("a[aria-current='page']", text: "3")
    end
  end

  describe "page_minimal type" do
    it "renders with secondary buttons" do
      render_inline(described_class.new(type: :page_minimal, current_page: 1, total_pages: 10))

      expect(page).to have_css("nav[aria-label='Pagination']")
    end
  end

  describe "card_minimal type" do
    it "renders page indicator text" do
      render_inline(described_class.new(type: :card_minimal, current_page: 3, total_pages: 10))

      expect(page).to have_text("Page 3 of 10")
    end

    it "renders prev and next buttons" do
      render_inline(described_class.new(type: :card_minimal, current_page: 3, total_pages: 10))

      expect(page).to have_text("Previous")
      expect(page).to have_text("Next")
    end
  end

  describe "button_group type" do
    it "renders inside button group" do
      render_inline(described_class.new(type: :button_group, current_page: 1, total_pages: 5))

      expect(page).to have_css("[role='group']")
    end
  end

  it "raises error for invalid type" do
    expect {
      described_class.new(type: :invalid)
    }.to raise_error(ArgumentError, /Invalid pagination type/)
  end
end
