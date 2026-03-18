# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::Stepper::Component, type: :component do
  it "renders step titles" do
    render_inline(described_class.new(current_step: 1)) do |stepper|
      stepper.with_step(title: "Your details", description: "Name and email")
      stepper.with_step(title: "Company details", description: "Website and location")
      stepper.with_step(title: "Invite your team", description: "Start collaborating")
      stepper.with_panel { "Step 1 content" }
      stepper.with_panel { "Step 2 content" }
      stepper.with_panel { "Step 3 content" }
    end

    expect(page).to have_text("Your details")
    expect(page).to have_text("Company details")
    expect(page).to have_text("Invite your team")
  end

  it "renders step descriptions" do
    render_inline(described_class.new(current_step: 1)) do |stepper|
      stepper.with_step(title: "Step 1", description: "First description")
      stepper.with_step(title: "Step 2", description: "Second description")
      stepper.with_panel { "Content 1" }
      stepper.with_panel { "Content 2" }
    end

    expect(page).to have_text("First description")
    expect(page).to have_text("Second description")
  end

  it "renders a nav with aria-label Progress" do
    render_inline(described_class.new(current_step: 1)) do |stepper|
      stepper.with_step(title: "Step 1")
      stepper.with_panel { "Content 1" }
    end

    expect(page).to have_css("nav[aria-label='Progress']")
  end

  it "shows active panel content for the current step" do
    render_inline(described_class.new(current_step: 2)) do |stepper|
      stepper.with_step(title: "Step 1")
      stepper.with_step(title: "Step 2")
      stepper.with_step(title: "Step 3")
      stepper.with_panel { "First panel content" }
      stepper.with_panel { "Second panel content" }
      stepper.with_panel { "Third panel content" }
    end

    expect(page).to have_css("[data-stepper-target='panel']:not(.hidden)", text: "Second panel content")
    expect(page).to have_css("[data-stepper-target='panel'].hidden", text: "First panel content")
    expect(page).to have_css("[data-stepper-target='panel'].hidden", text: "Third panel content")
  end

  it "marks the current step button with aria-current=step" do
    render_inline(described_class.new(current_step: 2)) do |stepper|
      stepper.with_step(title: "Step 1")
      stepper.with_step(title: "Step 2")
      stepper.with_step(title: "Step 3")
      stepper.with_panel { "Content 1" }
      stepper.with_panel { "Content 2" }
      stepper.with_panel { "Content 3" }
    end

    buttons = page.all("[data-stepper-target='stepButton']")
    expect(buttons[1]["aria-current"]).to eq("step")
    expect(buttons[0]["aria-current"]).to be_nil
    expect(buttons[2]["aria-current"]).to be_nil
  end

  it "hides the prev button on the first step" do
    render_inline(described_class.new(current_step: 1)) do |stepper|
      stepper.with_step(title: "Step 1")
      stepper.with_step(title: "Step 2")
      stepper.with_panel { "Content 1" }
      stepper.with_panel { "Content 2" }
    end

    expect(page).to have_css("[data-stepper-target='prevButton'].invisible")
  end

  it "shows the prev button after the first step" do
    render_inline(described_class.new(current_step: 2)) do |stepper|
      stepper.with_step(title: "Step 1")
      stepper.with_step(title: "Step 2")
      stepper.with_step(title: "Step 3")
      stepper.with_panel { "Content 1" }
      stepper.with_panel { "Content 2" }
      stepper.with_panel { "Content 3" }
    end

    expect(page).not_to have_css("[data-stepper-target='prevButton'].invisible")
  end

  it "shows a Continue button when not on the last step" do
    render_inline(described_class.new(current_step: 1)) do |stepper|
      stepper.with_step(title: "Step 1")
      stepper.with_step(title: "Step 2")
      stepper.with_panel { "Content 1" }
      stepper.with_panel { "Content 2" }
    end

    expect(page).to have_button("Continue")
  end

  it "shows a Finish button on the last step" do
    render_inline(described_class.new(current_step: 2)) do |stepper|
      stepper.with_step(title: "Step 1")
      stepper.with_step(title: "Step 2")
      stepper.with_panel { "Content 1" }
      stepper.with_panel { "Content 2" }
    end

    expect(page).to have_button("Finish")
    expect(page).not_to have_button("Continue")
  end

  it "renders a step counter" do
    render_inline(described_class.new(current_step: 2)) do |stepper|
      stepper.with_step(title: "Step 1")
      stepper.with_step(title: "Step 2")
      stepper.with_step(title: "Step 3")
      stepper.with_panel { "Content 1" }
      stepper.with_panel { "Content 2" }
      stepper.with_panel { "Content 3" }
    end

    expect(page).to have_text("Step 2 of 3")
  end

  it "renders with stimulus controller" do
    render_inline(described_class.new(current_step: 1)) do |stepper|
      stepper.with_step(title: "Step 1")
      stepper.with_panel { "Content 1" }
    end

    expect(page).to have_css("[data-controller='stepper']")
  end

  describe "step_state" do
    subject(:component) { described_class.new(current_step: 2) }

    it "returns :completed for steps before current" do
      expect(component.step_state(1)).to eq(:completed)
    end

    it "returns :current for the current step" do
      expect(component.step_state(2)).to eq(:current)
    end

    it "returns :upcoming for steps after current" do
      expect(component.step_state(3)).to eq(:upcoming)
    end
  end

  describe "CSS helper methods" do
    subject(:component) { described_class.new(current_step: 1) }

    it "applies brand color to the current step title" do
      expect(component.title_classes(:current)).to include("text-brand-secondary")
    end

    it "applies muted color to upcoming step titles" do
      expect(component.title_classes(:upcoming)).to include("text-tertiary")
    end

    it "uses filled connector for completed state" do
      expect(component.connector_classes(:completed)).to include("bg-brand-solid")
    end

    it "uses secondary connector for upcoming state" do
      expect(component.connector_classes(:upcoming)).to include("bg-secondary")
    end
  end

  it "accepts extra CSS classes" do
    render_inline(described_class.new(current_step: 1, class: "my-custom-class")) do |stepper|
      stepper.with_step(title: "Step 1")
      stepper.with_panel { "Content 1" }
    end

    expect(page).to have_css(".my-custom-class")
  end
end
