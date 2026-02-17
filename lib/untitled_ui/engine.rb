# frozen_string_literal: true

module UntitledUi
  class Engine < ::Rails::Engine
    isolate_namespace UntitledUi

    # Add gem's app/components to autoload paths so Ui:: resolves at top level
    initializer "untitled_ui.autoload", before: :set_autoload_paths do |app|
      app.config.autoload_paths.unshift(root.join("app", "components").to_s)
    end

    # Expose CSS assets for Tailwind imports
    initializer "untitled_ui.assets" do |app|
      app.config.assets.paths << root.join("app", "assets", "tailwind").to_s if app.config.respond_to?(:assets)
    end

    # Expose JS for importmap
    initializer "untitled_ui.importmap", before: "importmap" do |app|
      if app.respond_to?(:importmap)
        importmap_path = root.join("config", "importmap.rb")
        app.config.importmap.paths << importmap_path if importmap_path.exist?
      end
    end
  end
end
