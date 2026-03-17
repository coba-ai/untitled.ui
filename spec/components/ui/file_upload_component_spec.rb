# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::FileUpload::Component, type: :component do
  it "renders with default props" do
    render_inline(described_class.new)

    expect(page).to have_css("input[type='file']", visible: :all)
    expect(page).to have_text("Click to upload")
    expect(page).to have_text("or drag and drop")
  end

  it "renders with label" do
    render_inline(described_class.new(label: "Upload file"))

    expect(page).to have_text("Upload file")
  end

  it "renders with hint" do
    render_inline(described_class.new(hint: "SVG, PNG, JPG or GIF (max. 800x400px)"))

    expect(page).to have_text("SVG, PNG, JPG or GIF (max. 800x400px)")
  end

  it "renders with name attribute" do
    render_inline(described_class.new(name: "avatar"))

    expect(page).to have_css("input[name='avatar']", visible: :all)
  end

  it "renders with accept attribute" do
    render_inline(described_class.new(accept: "image/*,.pdf"))

    expect(page).to have_css("input[accept='image/*,.pdf']", visible: :all)
  end

  it "renders with multiple attribute" do
    render_inline(described_class.new(multiple: true))

    expect(page).to have_css("input[multiple]", visible: :all)
  end

  it "renders disabled state" do
    render_inline(described_class.new(disabled: true))

    expect(page).to have_css("input[disabled]", visible: :all)
  end

  it "renders invalid state" do
    render_inline(described_class.new(invalid: true, hint: "File is required"))

    expect(page).to have_text("File is required")
  end

  it "renders with custom id" do
    render_inline(described_class.new(id: "my-upload"))

    expect(page).to have_css("input[id='my-upload']", visible: :all)
  end

  it "attaches stimulus controller" do
    render_inline(described_class.new)

    expect(page).to have_css("[data-controller='file-upload']")
  end

  it "renders the upload cloud icon" do
    render_inline(described_class.new)

    expect(page).to have_css("svg")
  end
end
