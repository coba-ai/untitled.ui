# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::Timeline::Component, type: :component do
  it "renders items with title" do
    render_inline(described_class.new) do |timeline|
      timeline.with_item(title: "Application submitted")
      timeline.with_item(title: "Interview scheduled")
      timeline.with_item(title: "Offer sent")
    end

    expect(page).to have_text("Application submitted")
    expect(page).to have_text("Interview scheduled")
    expect(page).to have_text("Offer sent")
  end

  it "renders item descriptions" do
    render_inline(described_class.new) do |timeline|
      timeline.with_item(title: "Deploy started", description: "Deployment to production triggered")
      timeline.with_item(title: "Deploy complete")
    end

    expect(page).to have_text("Deployment to production triggered")
  end

  it "renders timestamps" do
    render_inline(described_class.new) do |timeline|
      timeline.with_item(title: "Event", timestamp: "3 min ago")
    end

    expect(page).to have_css("time", text: "3 min ago")
  end

  it "renders as an ordered list" do
    render_inline(described_class.new) do |timeline|
      timeline.with_item(title: "Step 1")
    end

    expect(page).to have_css("ol")
    expect(page).to have_css("li")
  end

  it "renders a dot when no icon is provided" do
    render_inline(described_class.new) do |timeline|
      timeline.with_item(title: "No icon item", color: :gray)
    end

    expect(page).to have_css("span.rounded-full")
  end

  it "renders a custom SVG icon" do
    icon = '<svg class="size-4" viewBox="0 0 24 24"><path d="M12 6v12" /></svg>'

    render_inline(described_class.new) do |timeline|
      timeline.with_item(title: "With icon", icon: icon)
    end

    expect(page).to have_css("svg")
  end

  it "does not render a connector after the last item" do
    render_inline(described_class.new) do |timeline|
      timeline.with_item(title: "First")
      timeline.with_item(title: "Last")
    end

    # The last <li> should have last:pb-0 class, indicating it's the final item
    expect(page).to have_css("li.last\\:pb-0")
  end

  describe "color variants" do
    %i[gray brand success error warning].each do |color|
      it "renders #{color} color variant" do
        component = Ui::Timeline::ItemComponent.new(title: "Test", color: color)
        expect(component.dot_classes).to be_a(String)
        expect(component.icon_wrapper_classes).to be_a(String)
      end
    end

    it "applies brand dot color" do
      item = Ui::Timeline::ItemComponent.new(title: "Brand", color: :brand)
      expect(item.dot_classes).to include("bg-brand-solid")
    end

    it "applies success dot color" do
      item = Ui::Timeline::ItemComponent.new(title: "Success", color: :success)
      expect(item.dot_classes).to include("bg-utility-success-500")
    end

    it "applies error dot color" do
      item = Ui::Timeline::ItemComponent.new(title: "Error", color: :error)
      expect(item.dot_classes).to include("bg-utility-error-500")
    end

    it "applies warning dot color" do
      item = Ui::Timeline::ItemComponent.new(title: "Warning", color: :warning)
      expect(item.dot_classes).to include("bg-utility-warning-500")
    end
  end

  it "accepts extra CSS classes on the root element" do
    render_inline(described_class.new(class: "max-w-md")) do |timeline|
      timeline.with_item(title: "Item")
    end

    expect(page).to have_css("ol.max-w-md")
  end

  it "marks the last item with last! flag" do
    component = described_class.new
    item1 = Ui::Timeline::ItemComponent.new(title: "First")
    item2 = Ui::Timeline::ItemComponent.new(title: "Last")

    allow(component).to receive(:items).and_return([item1, item2])

    prepared = component.prepared_items
    expect(prepared.last.last).to be(true)
    expect(prepared.first.last).to be(false)
  end
end
