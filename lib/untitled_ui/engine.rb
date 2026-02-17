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

    # Auto-create symlinks so Tailwind can resolve gem CSS and scan templates
    initializer "untitled_ui.symlinks", after: :load_config_initializers do |app|
      tailwind_dir = app.root.join("app", "assets", "tailwind")
      next unless tailwind_dir.directory?

      {
        "untitled_ui" => root.join("app", "assets", "tailwind", "untitled_ui"),
        "untitled_ui_components" => root.join("app", "components"),
        "untitled_ui_views" => root.join("app", "views")
      }.each do |name, target|
        link = tailwind_dir.join(name)
        next if link.exist? && link.readlink.to_s == target.to_s
        FileUtils.rm_f(link) if link.symlink?
        FileUtils.ln_sf(target, link)
      end
    rescue Errno::EPERM
      # Skip if filesystem doesn't allow symlinks (e.g. read-only containers)
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
