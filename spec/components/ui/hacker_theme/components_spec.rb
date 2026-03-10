# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Components under hacker theme", type: :component do
  before do
    UntitledUi.configuration.theme = :hacker
  end

  after do
    UntitledUi.configuration.theme = :default
  end

  describe Ui::Button::Component do
    it "renders all color variants" do
      %i[primary secondary tertiary link_gray link_color
         primary_destructive secondary_destructive tertiary_destructive link_destructive].each do |color|
        render_inline(described_class.new(color: color)) { "Button" }
        expect(page).to have_text("Button")
      end
    end

    it "renders primary with brand-solid background class" do
      render_inline(described_class.new(color: :primary)) { "Click" }
      expect(page).to have_css(".bg-brand-solid")
    end

    it "renders secondary with semantic ring class" do
      render_inline(described_class.new(color: :secondary)) { "Click" }
      expect(page).to have_css(".ring-primary")
    end

    it "renders all sizes" do
      %i[sm md lg xl].each do |size|
        render_inline(described_class.new(size: size)) { "Button" }
        expect(page).to have_text("Button")
      end
    end

    it "renders disabled state" do
      render_inline(described_class.new(disabled: true)) { "Disabled" }
      expect(page).to have_button("Disabled", disabled: true)
    end

    it "renders loading state" do
      render_inline(described_class.new(loading: true)) { "Loading" }
      expect(page).to have_css("[data-loading]")
    end
  end

  describe Ui::Badge::Component do
    it "renders all color variants" do
      %i[gray brand error warning success blue indigo purple pink orange].each do |color|
        render_inline(described_class.new(color: color)) { color.to_s }
        expect(page).to have_text(color.to_s)
      end
    end

    it "renders all type variants" do
      %i[pill_color badge_color badge_modern].each do |type|
        render_inline(described_class.new(type: type)) { "Badge" }
        expect(page).to have_text("Badge")
      end
    end
  end

  describe Ui::Input::Component do
    it "renders with label and placeholder" do
      render_inline(described_class.new(label: "Email", placeholder: "you@example.com"))
      expect(page).to have_text("Email")
      expect(page).to have_css("input[placeholder='you@example.com']")
    end

    it "renders invalid state" do
      render_inline(described_class.new(invalid: true))
      expect(page).to have_css("svg")
    end

    it "renders disabled state" do
      render_inline(described_class.new(disabled: true))
      expect(page).to have_css("input[disabled]")
    end
  end

  describe Ui::Toggle::Component do
    it "renders with label" do
      render_inline(described_class.new(label: "Dark mode"))
      expect(page).to have_text("Dark mode")
      expect(page).to have_css("[data-controller='toggle']")
    end
  end

  describe Ui::Avatar::Component do
    it "renders with initials across all sizes" do
      %i[xxs xs sm md lg xl].each do |size|
        render_inline(described_class.new(size: size, initials: "HK"))
        expect(page).to have_text("HK")
      end
    end

    it "renders status indicator" do
      render_inline(described_class.new(status: :online, initials: "X"))
      expect(page).to have_css("span")
    end
  end

  describe Ui::Modal::Component do
    it "renders with trigger and content" do
      render_inline(described_class.new) do |modal|
        modal.with_trigger { "Open" }
        "Modal content"
      end

      expect(page).to have_text("Open")
      expect(page).to have_css("dialog")
    end
  end

  describe Ui::Checkbox::Component do
    it "renders with label" do
      render_inline(described_class.new(label: "Accept terms"))
      expect(page).to have_text("Accept terms")
    end
  end

  describe Ui::Tooltip::Component do
    it "renders with title and trigger" do
      render_inline(described_class.new(title: "Helpful tip")) do |c|
        c.with_trigger { "Hover me" }
      end
      expect(page).to have_text("Hover me")
      expect(page).to have_css("[role='tooltip']")
    end
  end

  describe Ui::ProgressBar::Component do
    it "renders with value" do
      render_inline(described_class.new(value: 75))
      expect(page).to have_css("[role='progressbar']")
    end
  end

  describe Ui::Table::Component do
    it "renders with columns" do
      render_inline(described_class.new) do |table|
        table.with_column(label: "Name")
        "<tr><td>Alice</td></tr>".html_safe
      end
      expect(page).to have_css("table")
      expect(page).to have_text("Name")
    end
  end
end
