# frozen_string_literal: true

require "rails_helper"

RSpec.describe UntitledUi::ComponentConfig do
  describe ".build_props" do
    it "coerces select values to symbols" do
      props = described_class.build_props("button", { size: "lg", color: "secondary" })
      expect(props[:size]).to eq(:lg)
      expect(props[:color]).to eq(:secondary)
    end

    it "coerces checkbox values to booleans" do
      props = described_class.build_props("button", { disabled: "1", loading: "0" })
      expect(props[:disabled]).to eq(true)
      expect(props[:loading]).to eq(false)
    end

    it "coerces number values to integers" do
      props = described_class.build_props("progress_bar", { value: "75" })
      expect(props[:value]).to eq(75)
    end

    it "uses defaults when params are missing" do
      props = described_class.build_props("button", {})
      expect(props[:size]).to eq(:sm)
      expect(props[:color]).to eq(:primary)
      expect(props[:disabled]).to eq(false)
    end

    it "coerces 'none' select value to nil" do
      props = described_class.build_props("progress_bar", { label_position: "none" })
      expect(props[:label_position]).to be_nil
    end

    it "merges static_props into result" do
      props = described_class.build_props("select", {})
      expect(props[:options]).to be_an(Array)
      expect(props[:options].length).to eq(3)
      expect(props[:options].first[:label]).to eq("Apple")
    end

    it "skips :text param when component uses block content" do
      props = described_class.build_props("button", { text: "Click me" })
      expect(props).not_to have_key(:text)
    end

    it "includes :text param as kwarg when component does not use block content" do
      props = described_class.build_props("label", { text: "My label" })
      expect(props[:text]).to eq("My label")
    end

    it "returns empty hash for unknown component" do
      expect(described_class.build_props("nonexistent", {})).to eq({})
    end
  end

  describe ".build_content" do
    it "returns text content for components with content: true" do
      content = described_class.build_content("button", { text: "Save" })
      expect(content).to eq("Save")
    end

    it "returns default text when param is missing" do
      content = described_class.build_content("button", {})
      expect(content).to eq("Button")
    end

    it "returns nil for components without content" do
      content = described_class.build_content("alert", { text: "Hello" })
      expect(content).to be_nil
    end
  end

  describe ".playground_available?" do
    it "returns true for configured components" do
      expect(described_class.playground_available?("button")).to be(true)
      expect(described_class.playground_available?("alert")).to be(true)
      expect(described_class.playground_available?("select")).to be(true)
    end

    it "returns false for unconfigured components" do
      expect(described_class.playground_available?("nonexistent")).to be(false)
    end
  end

  describe ".code_snippet" do
    it "generates render call with props" do
      snippet = described_class.code_snippet("alert", { variant: :info, title: "Hello" }, nil)
      expect(snippet).to include("Ui::Alert::Component")
      expect(snippet).to include("variant: :info")
      expect(snippet).to include('title: "Hello"')
    end

    it "generates render call with content block" do
      snippet = described_class.code_snippet("button", { size: :sm }, "Click")
      expect(snippet).to include("{ \"Click\" }")
    end
  end
end
