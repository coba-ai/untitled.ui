# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::Stat::Component, type: :component do
  it "renders label and value" do
    render_inline(described_class.new(label: "Total Revenue", value: "$45,231"))

    expect(page).to have_text("Total Revenue")
    expect(page).to have_text("$45,231")
  end

  it "renders change and period" do
    render_inline(described_class.new(label: "Users", value: "2,420", change: "+12.5%", period: "vs last month"))

    expect(page).to have_text("+12.5%")
    expect(page).to have_text("vs last month")
  end

  it "renders with an icon" do
    icon_svg = '<svg class="size-5"><circle cx="10" cy="10" r="5"/></svg>'
    render_inline(described_class.new(label: "Revenue", value: "$10k", icon: icon_svg))

    expect(page).to have_css("svg")
  end

  it "auto-detects upward trend from + prefix" do
    component = described_class.new(label: "Sales", value: "100", change: "+20%")
    expect(component.trend).to eq(:up)
  end

  it "auto-detects downward trend from - prefix" do
    component = described_class.new(label: "Sales", value: "100", change: "-5%")
    expect(component.trend).to eq(:down)
  end

  it "auto-detects neutral trend when change is blank" do
    component = described_class.new(label: "Sales", value: "100")
    expect(component.trend).to eq(:neutral)
  end

  it "uses explicit trend over auto-detection" do
    component = described_class.new(label: "Sales", value: "100", change: "+20%", trend: :down)
    expect(component.trend).to eq(:down)
  end

  it "applies success color for upward trend" do
    component = described_class.new(label: "Sales", value: "100", change: "+10%")
    expect(component.trend_color).to include("success")
  end

  it "applies error color for downward trend" do
    component = described_class.new(label: "Sales", value: "100", change: "-10%")
    expect(component.trend_color).to include("error")
  end

  it "hides trend section when no change is provided" do
    render_inline(described_class.new(label: "Total", value: "500"))

    expect(page).not_to have_css("svg.size-4")
  end

  it "accepts custom classes" do
    render_inline(described_class.new(label: "Test", value: "1", class: "my-custom-class"))

    expect(page).to have_css(".my-custom-class")
  end
end
