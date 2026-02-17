require "rails_helper"

RSpec.describe Ui::ProgressSteps::Component, type: :component do
  let(:steps) do
    [
      { title: "Your details", description: "Name and email" },
      { title: "Company details", description: "Website and location" },
      { title: "Invite your team", description: "Start collaborating" },
      { title: "Add your socials", description: "Automatic sharing" }
    ]
  end

  it "renders all step titles" do
    render_inline(described_class.new(steps: steps, current_step: 1))

    steps.each { |s| expect(page).to have_text(s[:title]) }
  end

  it "renders descriptions" do
    render_inline(described_class.new(steps: steps, current_step: 0))

    expect(page).to have_text("Name and email")
    expect(page).to have_text("Website and location")
  end

  it "renders nav with aria-label" do
    render_inline(described_class.new(steps: steps, current_step: 0))

    expect(page).to have_css("nav[aria-label='Progress']")
  end

  describe "step states" do
    it "marks completed steps with checkmark" do
      render_inline(described_class.new(steps: steps, current_step: 2))

      # Steps 0 and 1 should be completed (have checkmark SVGs)
      expect(page).to have_css("svg", minimum: 2)
    end

    it "shows dot for upcoming steps without icons" do
      render_inline(described_class.new(steps: steps, current_step: 0))

      # Steps 1, 2, 3 are upcoming with no icons, so they get dots
      expect(page).to have_css("span.rounded-full", minimum: 3)
    end

    it "applies brand color to current step title" do
      component = described_class.new(steps: steps, current_step: 1)
      expect(component.title_classes(:current)).to include("text-brand-secondary")
    end

    it "applies muted color to upcoming step title" do
      component = described_class.new(steps: steps, current_step: 1)
      expect(component.title_classes(:upcoming)).to include("text-tertiary")
    end
  end

  describe "connectors" do
    it "renders connector lines between steps" do
      component = described_class.new(steps: steps, current_step: 2)

      expect(component.connector_classes(:completed)).to include("bg-brand-solid")
      expect(component.connector_classes(:upcoming)).to include("bg-secondary")
    end
  end

  it "renders custom icons" do
    icon = '<svg class="size-4" viewBox="0 0 24 24"><path d="M12 6v12" /></svg>'
    steps_with_icon = [{ title: "Step 1", icon: icon }]

    render_inline(described_class.new(steps: steps_with_icon, current_step: 0))

    expect(page).to have_css("svg")
  end
end
