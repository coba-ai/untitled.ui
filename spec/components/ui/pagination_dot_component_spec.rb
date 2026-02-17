require "rails_helper"

RSpec.describe Ui::Pagination::Dot::Component, type: :component do
  it "renders dots for each page" do
    render_inline(described_class.new(current_page: 1, total_pages: 3))

    expect(page).to have_css("a[aria-label]", count: 3)
  end

  it "marks current page" do
    render_inline(described_class.new(current_page: 2, total_pages: 3))

    expect(page).to have_css("a[aria-current='page']", count: 1)
  end

  it "renders with md size by default" do
    render_inline(described_class.new(current_page: 1, total_pages: 3))

    expect(page).to have_css("nav.gap-3")
  end

  it "renders with lg size" do
    render_inline(described_class.new(current_page: 1, total_pages: 3, size: :lg))

    expect(page).to have_css("nav.gap-4")
  end

  it "renders framed style" do
    render_inline(described_class.new(current_page: 1, total_pages: 3, framed: true))

    expect(page).to have_css("nav.rounded-full")
  end

  it "uses custom page_url" do
    render_inline(described_class.new(current_page: 1, total_pages: 3, page_url: ->(p) { "/slide/#{p}" }))

    expect(page).to have_css("a[href='/slide/1']")
    expect(page).to have_css("a[href='/slide/2']")
  end
end
