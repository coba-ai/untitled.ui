# frozen_string_literal: true

require "rails_helper"

class FormBuilderTestModel
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email, :string
  attribute :bio, :string
  attribute :notifications, :boolean
  attribute :plan, :string
  attribute :terms, :boolean

  def persisted?
    true
  end

  def to_key
    [1]
  end
end

RSpec.describe UntitledUi::FormBuilder do
  let(:object) do
    FormBuilderTestModel.new(email: "test@example.com", bio: "Hello", notifications: true, plan: "pro", terms: false)
  end
  let(:template) do
    controller = ActionController::Base.new
    controller.request = ActionDispatch::TestRequest.create
    controller.view_context
  end
  let(:builder) { described_class.new("user", object, template, {}) }

  describe "#ui_input" do
    it "renders with auto-populated name, value, and label" do
      result = builder.ui_input(:email, placeholder: "you@example.com")
      expect(result).to include("user[email]")
      expect(result).to include("test@example.com")
      expect(result).to include("Email")
    end

    it "generates an id attribute" do
      result = builder.ui_input(:email)
      expect(result).to include('id="user_email"')
    end

    it "associates label with input via for attribute" do
      result = builder.ui_input(:email)
      expect(result).to include('for="user_email"')
    end

    it "does not override explicitly provided values" do
      result = builder.ui_input(:email, value: "custom@example.com", label: "Custom")
      expect(result).to include("custom@example.com")
      expect(result).to include("Custom")
      expect(result).not_to include("test@example.com")
    end

    context "with validation errors" do
      before { object.errors.add(:email, "is invalid") }

      it "sets invalid state and shows error as hint" do
        result = builder.ui_input(:email)
        expect(result).to include("Email is invalid")
      end
    end
  end

  describe "#ui_textarea" do
    it "renders with auto-populated name and value" do
      result = builder.ui_textarea(:bio)
      expect(result).to include("textarea")
      expect(result).to include("user[bio]")
      expect(result).to include("Hello")
    end

    it "generates an id attribute" do
      result = builder.ui_textarea(:bio)
      expect(result).to include('id="user_bio"')
    end

    context "with validation errors" do
      before { object.errors.add(:bio, "is too short") }

      it "sets invalid state and shows error as hint" do
        result = builder.ui_textarea(:bio)
        expect(result).to include("Bio is too short")
      end
    end
  end

  describe "#ui_checkbox" do
    it "renders with auto-populated name and checked state" do
      result = builder.ui_checkbox(:notifications)
      expect(result).to include("user[notifications]")
      expect(result).to match(/<input[^>]*type="checkbox"[^>]*checked/)
    end

    it "generates an id attribute" do
      result = builder.ui_checkbox(:notifications)
      expect(result).to include('id="user_notifications"')
    end

    it "handles falsy values correctly" do
      result = builder.ui_checkbox(:terms)
      expect(result).to include("user[terms]")
      expect(result).not_to match(/<input[^>]*type="checkbox"[^>]*checked/)
    end
  end

  describe "#ui_toggle" do
    it "renders with auto-populated name and checked state" do
      result = builder.ui_toggle(:notifications)
      expect(result).to include("user[notifications]")
      expect(result).to match(/<input[^>]*type="checkbox"[^>]*checked/)
    end

    it "generates an id attribute" do
      result = builder.ui_toggle(:notifications)
      expect(result).to include('id="user_notifications"')
    end

    it "renders unchecked for falsy values" do
      result = builder.ui_toggle(:terms)
      expect(result).not_to match(/<input[^>]*type="checkbox"[^>]*checked/)
    end
  end

  describe "#ui_radio_button" do
    it "renders with auto-populated name and value" do
      result = builder.ui_radio_button(:plan, value: "pro")
      expect(result).to include("user[plan]")
      expect(result).to include('value="pro"')
    end

    it "checks radio when value matches model" do
      result = builder.ui_radio_button(:plan, value: "pro")
      expect(result).to match(/<input[^>]*checked/)
    end

    it "does not check radio when value differs from model" do
      result = builder.ui_radio_button(:plan, value: "free")
      expect(result).not_to match(/<input[^>]*checked/)
    end

    it "generates a value-scoped id attribute" do
      result = builder.ui_radio_button(:plan, value: "pro")
      expect(result).to include('id="user_plan_pro"')
    end

    it "auto-generates label from value" do
      result = builder.ui_radio_button(:plan, value: "pro")
      expect(result).to include("Pro")
    end
  end

  describe "#ui_button" do
    it "renders a submit button with text" do
      result = builder.ui_button("Save")
      expect(result).to include("Save")
    end

    it "defaults to submit type" do
      result = builder.ui_button("Go")
      expect(result).to include('type="submit"')
    end

    it "defaults to 'Submit' when no text or block given" do
      result = builder.ui_button
      expect(result).to include("Submit")
    end
  end
end
