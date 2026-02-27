# frozen_string_literal: true

pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin_all_from UntitledUi::Engine.root.join("app/javascript/untitled_ui"),
             under: "untitled_ui",
             to: "untitled_ui"
