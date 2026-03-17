# Untitled UI - Development Guide

## Project Overview
Rails engine gem providing a ViewComponent-based design system with Tailwind CSS v4.

## Architecture
- Components live in `app/components/ui/` and extend `Ui::Base`
- Use `cx()` for class merging, `binding.local_variable_get(:class)` for extra_classes
- Use frozen hashes for style variants (SIZE_STYLES, COLOR_STYLES, etc.)
- Stimulus controllers in `app/javascript/untitled_ui/`
- Specs in `spec/components/ui/` using `render_inline` and `expect(page)`
- Design system examples in `app/views/untitled_ui/design_system/components/examples/`
- Tailwind CSS v4 with semantic color tokens (`bg-primary`, `text-secondary`, `ring-primary`, etc.)

## Adding New Components
Use the scaffold generator:

```bash
# Basic component
rails g untitled_ui:scaffold component_name

# With Stimulus controller
rails g untitled_ui:scaffold component_name --stimulus

# With slots
rails g untitled_ui:scaffold component_name --slots=header,footer

# With typed props
rails g untitled_ui:scaffold component_name --props=size:select:sm:md:lg,disabled:boolean
```

This generates: component.rb, component.html.erb, spec, design system example, and registers in the COMPONENTS array and index.js.

## Key Patterns
- ViewComponent slots: `renders_one :header`, `renders_many :items`
- Nested component rendering with `with_content()` instead of block `{ }` (ViewComponent 4.x quirk)
- Design system examples use `render "untitled_ui/design_system/shared/example_section"` and `render "untitled_ui/design_system/shared/code_block"`
- Register new components in `app/controllers/untitled_ui/design_system/components_controller.rb` COMPONENTS array
- Register Stimulus controllers in `app/javascript/untitled_ui/index.js`

## Theme System
- Themes generated via `rails g untitled_ui:theme name --preset=corporate|ocean|warm|dark`
- `--dark` flag inverts semantic tokens for dark backgrounds
- Dark variants auto-generated for each preset
- Theme switcher + dark toggle in design system sidebar
- Tailwind v4 internal variables (`--background-color-*`, `--text-color-*`, etc.) must be re-mapped in generated themes

## Testing
```bash
bundle exec rspec                          # full suite
bundle exec rspec spec/components/ui/      # all component specs
bundle exec rspec spec/components/ui/button_component_spec.rb  # single component
```

## Design System
- Mounted at `/design_system` in host apps
- Views served from gem (not copied to host app)
- Only example partials are copied during install
- Routes: `/design_system/components`, `/design_system/components/:id`
