# UntitledUi

A ViewComponent-based design system implementing Untitled UI tokens, components, and patterns for Rails applications with Tailwind CSS v4.

## Requirements

- Ruby >= 3.1
- Rails >= 7.1
- [ViewComponent](https://viewcomponent.org/) >= 3.0
- [Tailwind CSS v4](https://tailwindcss.com/) with `@import "tailwindcss"`
- [Importmap-rails](https://github.com/rails/importmap-rails) (for Stimulus controllers)
- [Propshaft](https://github.com/rails/propshaft) (asset pipeline)

## Installation

Add the gem to your `Gemfile`:

```ruby
# From GitHub
gem "untitled_ui", github: "coba-ai/untitled.ui", branch: "main"

# Or from a local path during development
gem "untitled_ui", path: "../untitled_ui"
```

Then run:

```bash
bundle install
```

### Run the Install Generator

```bash
rails generate untitled_ui:install
```

The generator performs the following steps:

1. **Copies a brand color template** to `app/assets/tailwind/untitled_ui_colors.css`. This file contains CSS custom properties for your brand palette (primary, secondary, neutral, and dark mode colors). Edit this file to match your brand.

2. **Copies Untitled UI templates into your app**:
   - `app/components/ui/**` (component classes and templates)
   - `app/views/untitled_ui/**` (design system views)
   - `app/assets/tailwind/untitled_ui/**` (theme, typography, globals CSS)

3. **Creates local scan symlinks** in `app/assets/tailwind/`:
   - `untitled_ui_components` -> `app/components`
   - `untitled_ui_views` -> `app/views`

4. **Injects CSS imports** into your `app/assets/tailwind/application.css`:
   ```css
   @import "./untitled_ui/theme.css";
   @import "./untitled_ui/typography.css";
   @import "./untitled_ui/globals.css";
   @source "./untitled_ui_components/**/*.erb";
   @source "./untitled_ui_components/**/*.rb";
   @source "./untitled_ui_views/**/*.erb";
   ```
   The `@source` directives tell Tailwind v4 to scan installed app templates/classes for class names.

5. **Mounts the engine** in your `config/routes.rb`:
   ```ruby
   mount UntitledUi::Engine => "/design_system"
   ```
   This gives you a built-in design system browser at `/design_system` with live examples for every component.

6. **Registers Stimulus controllers** in `app/javascript/controllers/index.js` for interactive components (checkbox, dropdown, modal, tabs, toggle, tooltip).

## Usage

### Components

Use components in any view:

```erb
<%= render(Ui::Button::Component.new(color: :primary, size: :md)) { "Click me" } %>

<%= render Ui::Input::Component.new(label: "Email", placeholder: "you@example.com") %>

<%= render(Ui::Badge::Component.new(color: :success)) { "Active" } %>

<%= render Ui::Modal::Component.new do |modal| %>
  <% modal.with_trigger { "Open" } %>
  <% modal.with_header { "Modal Title" } %>
  Modal content here
<% end %>
```

### Available Components

| Category | Components |
|----------|-----------|
| **Actions** | Button, ButtonGroup, CloseButton, Dropdown |
| **Feedback** | Badge, ProgressBar, LoadingIndicator, EmptyState |
| **Forms** | Input, Textarea, Checkbox, Toggle, RadioButton, Label, HintText |
| **Data Display** | Avatar, Table, Tabs, DotIcon, FeaturedIcon |
| **Overlays** | Modal, Tooltip |

### Design System Browser

Visit `/design_system` to browse all components with live, interactive examples and copy-to-clipboard code snippets.

### Customizing Brand Colors

Edit `app/assets/tailwind/untitled_ui_colors.css` to customize your brand palette. The Untitled UI token system automatically cascades your brand colors through all semantic tokens used by the components.

## Development

```bash
bundle install
bundle exec rspec
```

## License

MIT
