# UntitledUi

A ViewComponent-based design system implementing Untitled UI tokens, components, and patterns for Rails applications with Tailwind CSS v4.

## Requirements

- Ruby >= 3.2
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

1. **Copies a brand color template** to `app/assets/tailwind/untitled_ui_colors.css`. It starts with the default Untitled UI palette and can be edited to match your brand.

2. **Copies Untitled UI templates into your app**:
   - `app/components/ui/**` (component classes and templates)
   - `app/views/untitled_ui/**` (design system views)
   - `app/views/layouts/untitled_ui/**` (design system layout)
   - `app/assets/tailwind/untitled_ui/**` (theme, typography, globals, hacker CSS)

3. **Injects CSS imports** into your `app/assets/tailwind/application.css`:
   ```css
   @import "./untitled_ui/theme.css";
   @import "./untitled_ui/typography.css";
   @import "./untitled_ui/globals.css";
   @import "./untitled_ui/hacker.css";
   @import "./untitled_ui_colors.css";
   @source "../../components/**/*.erb";
   @source "../../components/**/*.rb";
   @source "../../views/**/*.erb";
   ```

4. **Mounts the engine** in your `config/routes.rb`:
   ```ruby
   mount UntitledUi::Engine => "/design_system"
   ```
   This gives you a built-in design system browser at `/design_system` with live examples for every component.

5. **Registers Stimulus controllers** in `app/javascript/controllers/index.js` for interactive components (checkbox, dropdown, modal, tabs, toggle, tooltip).

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
| **Navigation** | Sidebar, Header, MobileHeader, Item, ItemButton, AccountCard, List |
| **Layout** | Pagination, ProgressSteps |

### Design System Browser

Visit `/design_system` to browse all components with live, interactive examples and copy-to-clipboard code snippets.

### Customizing Brand Colors

Edit `app/assets/tailwind/untitled_ui_colors.css` to customize your brand palette. The Untitled UI token system automatically cascades your brand colors through all semantic tokens used by the components.

## Themes

UntitledUi ships with two themes: the default clean/professional theme and a **hacker theme** (terminal-inspired with neon green accents, monospace fonts, and dark backgrounds).

### Theme Toggle in the Design System

The design system browser (`/design_system`) includes a theme toggle button in the sidebar. Click the terminal icon to switch to the hacker theme. The preference is saved in localStorage and persists across page reloads.

### Setting the Default Theme

Configure the default theme in an initializer:

```ruby
# config/initializers/untitled_ui.rb
UntitledUi.configure do |config|
  config.theme = :hacker  # :default or :hacker
end
```

### Using the Theme in Your Own Layouts

Add the theme class to your `<body>` tag using the provided helper:

```erb
<body class="<%= untitled_ui_theme_class %>">
```

Or toggle it with JavaScript for client-side switching:

```javascript
// Enable hacker theme
document.body.classList.add('hacker-theme');

// Disable hacker theme
document.body.classList.remove('hacker-theme');
```

### How It Works

The hacker theme uses CSS variable overrides scoped under the `.hacker-theme` class selector. This follows the same pattern as the built-in `.dark-mode` support in `theme.css`. When `.hacker-theme` is present on the body:

- **Fonts**: `--font-body` and `--font-display` resolve to JetBrains Mono / IBM Plex Mono
- **Border radius**: All `--radius-*` values become `2px` (sharp terminal aesthetic), except `--radius-full` which stays `9999px` for avatars
- **Shadows**: Skeuomorphic shadows are replaced with subtle green glow effects
- **Colors**: Full dark palette with neon green (`#00ff88`) as the brand color, terminal-appropriate error/warning/success colors

No component code changes are needed — all Tailwind utilities resolve through CSS custom properties that the theme overrides.

### Hacker Utility Classes

The hacker theme also provides optional utility classes for enhanced terminal effects:

| Class | Effect |
|-------|--------|
| `hacker-glow` | Green glow box-shadow |
| `hacker-scanlines` | CRT scanline overlay via `::after` |
| `hacker-grid-bg` | Subtle grid background pattern |
| `hacker-glitch` | Glitch animation |
| `hacker-cursor` | Blinking cursor via `::after` |

## Development

```bash
bundle install
bundle exec rspec
```

## License

MIT
