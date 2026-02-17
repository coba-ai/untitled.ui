# frozen_string_literal: true

module Ui
  module Navigation
    module MobileHeader
      class Component < Ui::Base
        renders_one :logo
        renders_one :sidebar_content

        def initialize(**_opts); end
      end
    end
  end
end
