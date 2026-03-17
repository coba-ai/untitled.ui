# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::TagInput::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new)

    expect(page).to have_css("[data-controller='tag-input']")
    expect(page).to have_css("input[type='text']")
    expect(page).to have_css("input[type='hidden']", visible: :hidden)
  end

  it "renders with placeholder" do
    render_inline(described_class.new(placeholder: "Enter tags..."))

    expect(page).to have_css("input[placeholder='Enter tags...']")
  end

  it "renders with label" do
    render_inline(described_class.new(label: "Skills"))

    expect(page).to have_text("Skills")
  end

  it "renders with hint" do
    render_inline(described_class.new(hint: "Press Enter to add a tag"))

    expect(page).to have_text("Press Enter to add a tag")
  end

  it "renders initial tags from array" do
    render_inline(described_class.new(value: ["ruby", "rails", "javascript"]))

    expect(page).to have_text("ruby")
    expect(page).to have_text("rails")
    expect(page).to have_text("javascript")
    expect(page).to have_css("[data-tag-input-target='tag']", count: 3)
  end

  it "renders initial tags from comma-separated string" do
    render_inline(described_class.new(value: "ruby,rails,javascript"))

    expect(page).to have_text("ruby")
    expect(page).to have_text("rails")
    expect(page).to have_text("javascript")
    expect(page).to have_css("[data-tag-input-target='tag']", count: 3)
  end

  it "renders hidden input with comma-separated value" do
    render_inline(described_class.new(name: "tags", value: ["ruby", "rails"]))

    expect(page).to have_css("input[type='hidden'][name='tags'][value='ruby,rails']", visible: :hidden)
  end

  it "renders with name and id" do
    render_inline(described_class.new(name: "skills", id: "user_skills"))

    expect(page).to have_css("input[type='hidden'][name='skills'][id='user_skills']", visible: :hidden)
  end

  it "renders remove buttons for each tag" do
    render_inline(described_class.new(value: ["ruby", "rails"]))

    expect(page).to have_css("button[aria-label='Remove ruby']")
    expect(page).to have_css("button[aria-label='Remove rails']")
  end

  it "renders without remove buttons when disabled" do
    render_inline(described_class.new(value: ["ruby", "rails"], disabled: true))

    expect(page).not_to have_css("button[aria-label='Remove ruby']")
    expect(page).not_to have_css("button[aria-label='Remove rails']")
  end

  it "renders disabled state on text input" do
    render_inline(described_class.new(disabled: true))

    expect(page).to have_css("input[type='text'][disabled]")
  end

  it "renders invalid state" do
    render_inline(described_class.new(invalid: true))

    expect(page).to have_css("[data-controller='tag-input']")
  end

  it "renders invalid state with hint" do
    render_inline(described_class.new(invalid: true, hint: "Tags are required"))

    expect(page).to have_text("Tags are required")
  end

  it "renders with max_tags data attribute" do
    render_inline(described_class.new(max_tags: 5))

    expect(page).to have_css("[data-tag-input-max-tags-value='5']")
  end

  it "renders the Stimulus controller attribute" do
    render_inline(described_class.new)

    expect(page).to have_css("[data-controller='tag-input']")
  end

  it "renders with custom class" do
    render_inline(described_class.new(class: "my-custom-class"))

    expect(page).to have_css(".my-custom-class")
  end

  it "handles empty value gracefully" do
    render_inline(described_class.new(value: []))

    expect(page).not_to have_css("[data-tag-input-target='tag']")
  end

  it "handles nil value gracefully" do
    render_inline(described_class.new(value: nil))

    expect(page).not_to have_css("[data-tag-input-target='tag']")
  end

  it "trims whitespace from comma-separated string values" do
    render_inline(described_class.new(value: " ruby , rails , javascript "))

    expect(page).to have_text("ruby")
    expect(page).to have_text("rails")
    expect(page).to have_text("javascript")
    expect(page).to have_css("[data-tag-input-target='tag']", count: 3)
  end
end
