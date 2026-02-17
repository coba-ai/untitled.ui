# frozen_string_literal: true

module Ui
  module Navigation
    module AccountCard
      class Component < Ui::Base
        attr_reader :name, :email, :avatar_src, :status, :extra_classes

        renders_one :menu

        def initialize(name:, email:, avatar_src: nil, status: :online, class: nil, **_opts)
          @name = name
          @email = email
          @avatar_src = avatar_src
          @status = status.to_sym
          @extra_classes = binding.local_variable_get(:class)
        end

        def card_classes
          cx("relative flex items-center gap-3 rounded-xl p-3 ring-1 ring-secondary ring-inset", @extra_classes)
        end
      end
    end
  end
end
