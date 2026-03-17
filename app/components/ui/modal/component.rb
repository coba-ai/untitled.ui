# frozen_string_literal: true

module Ui
  module Modal
    class Component < Ui::Base
      attr_reader :open, :extra_classes, :modal_id

      renders_one :trigger
      renders_one :header
      renders_one :footer

      def initialize(open: false, id: nil, class: nil, **_opts)
        @open = open
        @modal_id = id || "modal-#{SecureRandom.hex(4)}"
        @extra_classes = binding.local_variable_get(:class)
      end

      def overlay_classes
        "hidden open:fixed open:inset-0 open:z-50 open:flex open:min-h-dvh open:w-full open:items-end open:justify-center open:overflow-y-auto bg-overlay/70 px-4 pt-4 pb-4 outline-hidden backdrop-blur-[6px] sm:open:items-center sm:open:justify-center sm:open:p-8"
      end

      def dialog_classes
        cx(
          "max-h-full w-full max-w-lg rounded-xl bg-primary shadow-xl ring-1 ring-secondary_alt outline-hidden",
          @extra_classes
        )
      end
    end
  end
end
