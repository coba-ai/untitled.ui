require "rails_helper"

RSpec.describe Ui::Navigation::Sidebar::Component, type: :component do
  let(:icon_svg) { '<svg class="size-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path d="M12 6v12" /></svg>' }
  let(:items) { [{ label: "Dashboard", href: "/dashboard", icon: icon_svg }] }

  describe "simple type" do
    it "renders a sidebar" do
      render_inline(described_class.new(type: :simple, items: items))

      expect(page).to have_css("aside")
      expect(page).to have_text("Dashboard")
    end

    it "renders logo slot" do
      render_inline(described_class.new(type: :simple, items: items)) do |sidebar|
        sidebar.with_logo { "<span>Logo</span>".html_safe }
      end

      expect(page).to have_text("Logo")
    end

    it "renders account card slot" do
      render_inline(described_class.new(type: :simple, items: items)) do |sidebar|
        sidebar.with_account_card { "<div>Account</div>".html_safe }
      end

      expect(page).to have_text("Account")
    end
  end

  describe "slim type" do
    it "renders icon-only sidebar with secondary panel" do
      render_inline(described_class.new(type: :slim, items: items))

      expect(page).to have_css("[data-controller='navigation-sidebar']")
      expect(page).to have_css("[data-navigation-sidebar-target='secondaryPanel']")
    end

    it "has correct width" do
      component = described_class.new(type: :slim, items: items)
      expect(component.main_width).to eq(68)
      expect(component.secondary_width).to eq(268)
    end
  end

  describe "dual_tier type" do
    it "renders with secondary panel" do
      render_inline(described_class.new(type: :dual_tier, items: items))

      expect(page).to have_css("[data-controller='navigation-sidebar']")
    end

    it "has correct width" do
      component = described_class.new(type: :dual_tier, items: items)
      expect(component.main_width).to eq(296)
      expect(component.secondary_width).to eq(256)
    end
  end

  describe "section_dividers type" do
    it "renders with card style" do
      render_inline(described_class.new(type: :section_dividers, items: items))

      expect(page).to have_css("aside")
    end

    it "has correct width" do
      component = described_class.new(type: :section_dividers, items: items)
      expect(component.main_width).to eq(292)
    end
  end

  describe "section_subheadings type" do
    let(:grouped_items) { [{ label: "General", items: items }] }

    it "renders grouped items with labels" do
      render_inline(described_class.new(type: :section_subheadings, items: grouped_items))

      expect(page).to have_text("General")
      expect(page).to have_text("Dashboard")
    end
  end

  it "renders mobile header" do
    render_inline(described_class.new(type: :simple, items: items))

    expect(page).to have_css("[data-controller='navigation-mobile']")
  end

  it "raises error for invalid type" do
    expect {
      described_class.new(type: :invalid, items: items)
    }.to raise_error(ArgumentError, /Invalid sidebar type/)
  end
end
