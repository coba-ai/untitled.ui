# frozen_string_literal: true

require "rails_helper"

RSpec.describe UntitledUi::FormBuilder do
  let(:object) do
    obj = OpenStruct.new(email: "test@example.com", bio: "Hello", notifications: true, plan: "pro")
    errors = ActiveModel::Errors.new(obj)
    allow(obj).to receive(:errors).and_return(errors)
    allow(obj).to receive(:to_model).and_return(obj)
    allow(obj).to receive(:model_name).and_return(ActiveModel::Name.new(nil, nil, "User"))
    allow(obj).to receive(:to_key).and_return([1])
    allow(obj).to receive(:persisted?).and_return(true)
    obj
  end
  let(:template) do
    controller = ActionController::Base.new
    controller.request = ActionDispatch::TestRequest.create
    controller.view_context
  end
  let(:builder) { described_class.new("user", object, template, {}) }

  describe "#ui_input" do
    it "renders an input component with auto-populated attributes" do
      result = builder.ui_input(:email, placeholder: "you@example.com")
      expect(result).to include("user[email]")
      expect(result).to include("test@example.com")
    end

    it "auto-generates label from method name" do
      result = builder.ui_input(:email)
      expect(result).to include("Email")
    end
  end

  describe "#ui_textarea" do
    it "renders a textarea component" do
      result = builder.ui_textarea(:bio)
      expect(result).to include("textarea")
      expect(result).to include("user[bio]")
    end
  end

  describe "#ui_checkbox" do
    it "renders a checkbox component" do
      result = builder.ui_checkbox(:notifications)
      expect(result).to include("user[notifications]")
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
  end
end
