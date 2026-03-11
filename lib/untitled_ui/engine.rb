# frozen_string_literal: true

module UntitledUi
  class Engine < ::Rails::Engine
    isolate_namespace UntitledUi

    # Add gem's app/components to autoload paths so Ui:: resolves at top level
    initializer "untitled_ui.autoload", before: :set_autoload_paths do |app|
      components_path = root.join("app", "components").to_s
      unless app.config.autoload_paths.frozen?
        app.config.autoload_paths << components_path unless app.config.autoload_paths.include?(components_path)
      end
      app.config.eager_load_paths << components_path unless app.config.eager_load_paths.include?(components_path)
    end

    # Add app/components to view paths so partials in component directories can be found
    initializer "untitled_ui.view_paths" do
      ActiveSupport.on_load(:action_controller) do
        append_view_path UntitledUi::Engine.root.join("app", "components")
      end
    end

    # Auto-include ThemeHelper in all controllers
    initializer "untitled_ui.helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        helper UntitledUi::ThemeHelper
      end
    end

    # Expose CSS assets for Tailwind imports
    initializer "untitled_ui.assets" do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.paths << root.join("app", "assets", "tailwind").to_s
        app.config.assets.paths << root.join("app", "javascript").to_s
      end
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
