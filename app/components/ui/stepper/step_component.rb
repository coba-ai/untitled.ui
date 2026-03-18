# frozen_string_literal: true

module Ui
  module Stepper
    class StepComponent < Ui::Base
      attr_reader :title, :description

      def initialize(title:, description: nil, **_opts)
        @title = title
        @description = description
      end
    end
  end
end
