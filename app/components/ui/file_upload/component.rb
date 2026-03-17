# frozen_string_literal: true

module Ui
  module FileUpload
    class Component < Ui::Base
      ZONE_CLASSES = "flex w-full cursor-pointer flex-col items-center justify-center rounded-xl border border-dashed border-secondary px-6 py-4 transition-colors duration-150"

      attr_reader :name, :accept, :multiple, :max_size, :label, :hint,
                  :disabled, :invalid, :id, :extra_classes

      def initialize(
        name: nil, accept: nil, multiple: false, max_size: nil,
        label: nil, hint: nil, disabled: false, invalid: false,
        id: nil, class: nil, **_opts
      )
        @name = name
        @accept = accept
        @multiple = multiple
        @max_size = max_size
        @label = label
        @hint = hint
        @disabled = disabled
        @invalid = invalid
        @id = id
        @extra_classes = binding.local_variable_get(:class)
      end

      def zone_classes
        cx(
          ZONE_CLASSES,
          !@disabled && !@invalid && "hover:bg-primary_hover",
          @invalid && "border-error_subtle",
          @disabled && "cursor-not-allowed opacity-50"
        )
      end

      def input_id
        @id || "file_upload_#{object_id}"
      end
    end
  end
end
