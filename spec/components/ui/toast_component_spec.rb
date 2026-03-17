# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::Toast::Component, type: :component do
  it "renders with required title" do
    render_inline(described_class.new(title: "Success!"))

    expect(page).to have_text("Success!")
    expect(page).to have_css("[role='alert']")
  end

  it "renders title and description" do
    render_inline(described_class.new(title: "Saved", description: "Your changes have been saved."))

    expect(page).to have_text("Saved")
    expect(page).to have_text("Your changes have been saved.")
  end

  it "renders all variant types" do
    %i[success error warning info].each do |variant|
      render_inline(described_class.new(title: "Test", variant: variant))
      expect(page).to have_text("Test")
    end
  end

  it "renders all sizes" do
    %i[sm md].each do |size|
      render_inline(described_class.new(title: "Test", size: size))
      expect(page).to have_text("Test")
    end
  end

  it "renders close button when dismissible" do
    render_inline(described_class.new(title: "Test", dismissible: true))

    expect(page).to have_css("button[aria-label='Dismiss notification']")
  end

  it "hides close button when not dismissible" do
    render_inline(described_class.new(title: "Test", dismissible: false))

    expect(page).not_to have_css("button[aria-label='Dismiss notification']")
  end

  it "sets stimulus data attributes for auto-dismiss" do
    render_inline(described_class.new(title: "Test", auto_dismiss: true, duration: 3000))

    expect(page).to have_css("[data-controller='toast']")
    expect(page).to have_css("[data-toast-auto-dismiss-value='true']")
    expect(page).to have_css("[data-toast-duration-value='3000']")
  end

  it "renders custom content via block" do
    render_inline(described_class.new(title: "Test")) do
      "<button>Undo</button>".html_safe
    end

    expect(page).to have_css("button", text: "Undo")
  end

  it "applies extra classes" do
    render_inline(described_class.new(title: "Test", class: "my-custom-class"))

    expect(page).to have_css(".my-custom-class")
  end

  it "renders variant-specific icon" do
    render_inline(described_class.new(title: "Test", variant: :success))

    expect(page).to have_css("svg")
  end
end
