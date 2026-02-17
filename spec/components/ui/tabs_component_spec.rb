require "rails_helper"

RSpec.describe Ui::Tabs::Component, type: :component do
  it "renders with tabs" do
    render_inline(described_class.new) do |tabs|
      tabs.with_tab(id: "t1", label: "Tab 1", active: true)
      tabs.with_tab(id: "t2", label: "Tab 2")
      tabs.with_panel { "Panel 1" }
      tabs.with_panel { "Panel 2" }
    end

    expect(page).to have_text("Tab 1")
    expect(page).to have_text("Tab 2")
  end

  it "renders all type variants" do
    %i[button_brand button_gray underline].each do |type|
      render_inline(described_class.new(type: type)) do |tabs|
        tabs.with_tab(id: "t1", label: "Tab", active: true)
        tabs.with_panel { "Content" }
      end
      expect(page).to have_text("Tab")
    end
  end
end
