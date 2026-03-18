# Untitled UI

A comprehensive ViewComponent-based design system for Rails applications, implementing Untitled UI tokens, components, and patterns with Tailwind CSS v4.

## Requirements

- Ruby >= 3.2
- Rails >= 7.1
- [ViewComponent](https://viewcomponent.org/) >= 3.0
- [Tailwind CSS v4](https://tailwindcss.com/) with `@import "tailwindcss"`
- [Stimulus](https://stimulus.hotwired.dev/) (for interactive components)

## Installation

Add the gem to your `Gemfile`:

```ruby
gem "untitled_ui", github: "coba-ai/untitled.ui", branch: "main"
```

Then run:

```bash
bundle install
rails generate untitled_ui:install
```

The install generator:
1. Copies Tailwind CSS theme files and a brand color template
2. Creates `@source` directives so Tailwind scans gem components and views
3. Copies component example partials for the design system
4. Cleans up stale view overrides from previous installs
5. Mounts the engine at `/design_system`
6. Dynamically discovers and registers all Stimulus controllers

## Usage

```erb
<%= render(Ui::Button::Component.new(color: :primary, size: :md)) { "Click me" } %>

<%= render Ui::Input::Component.new(label: "Email", placeholder: "you@example.com") %>

<%= render(Ui::Badge::Component.new(color: :success)) { "Active" } %>
```

## Components

### Base Components

| Component | Description | Props |
|-----------|-------------|-------|
| **Alert** | Persistent banner with info/success/warning/error variants | `title:`, `description:`, `variant:`, `dismissible:`, `icon:` |
| **Avatar** | User avatar with image, initials, or placeholder | `name:`, `src:`, `size:` |
| **Badge** | Status indicator with pill/badge types, 10 colors | `type:`, `size:`, `color:`, `dot:`, `dismissible:` |
| **Button** | Versatile button with sizes, colors, icons, loading | `size:`, `color:`, `tag:`, `href:`, `disabled:`, `loading:` |
| **Card** | Content container with header, footer, media slots | `padding:`, `shadow:`, `border:`, `rounded:` |
| **Checkbox** | Checkbox with visual indicator, label, hint | `size:`, `label:`, `hint:`, `checked:`, `disabled:` |
| **Close Button** | Accessible close button with size/theme variants | `size:`, `theme:` |
| **Color Picker** | Color picker with swatch grid and hex input | `name:`, `value:`, `label:`, `swatches:`, `disabled:` |
| **Date Picker** | Calendar dropdown with month navigation | `name:`, `value:`, `label:`, `min:`, `max:`, `format:` |
| **Dot Icon** | Simple colored dot indicator | `size:`, `color:` |
| **Featured Icon** | Icon container with light/dark/modern/outline themes | `theme:`, `color:`, `size:` |
| **File Upload** | Drag-and-drop upload zone with click fallback | `name:`, `accept:`, `multiple:`, `max_size:`, `label:` |
| **Hint Text** | Helper text for form fields | `invalid:` |
| **Input** | Text input with label, hint, icon, validation | `size:`, `label:`, `hint:`, `placeholder:`, `invalid:`, `id:` |
| **Label** | Form label with required asterisk and tooltip | `text:`, `required:`, `tooltip:`, `for_id:` |
| **Loading Indicator** | Animated spinner | `type:`, `size:`, `label:` |
| **Progress Bar** | Progress bar with value, label, percentage | `value:`, `label:` |
| **Radio Button** | Radio button with dot indicator, label, hint | `size:`, `label:`, `hint:`, `checked:`, `name:`, `value:` |
| **Select** | Dropdown select with search, keyboard navigation | `name:`, `options:`, `searchable:`, `label:`, `placeholder:` |
| **Skeleton** | Loading placeholder with text/circular/rectangular | `variant:`, `lines:`, `width:`, `height:`, `animated:` |
| **Slider** | Range slider with brand-colored fill track | `name:`, `value:`, `min:`, `max:`, `step:`, `label:` |
| **Tag Input** | Multi-value input with pills, add/remove | `name:`, `value:`, `placeholder:`, `max_tags:`, `label:` |
| **Textarea** | Multi-line text input with label, hint, validation | `label:`, `hint:`, `placeholder:`, `rows:`, `invalid:` |
| **Toggle** | Toggle switch with track/thumb animation | `size:`, `label:`, `hint:`, `checked:`, `disabled:` |
| **Tooltip** | Tooltip with title, description, placement | `title:`, `description:`, `placement:` |

### Application Components

| Component | Description | Props |
|-----------|-------------|-------|
| **Accordion** | Collapsible sections, single/multiple open | `multiple:` + `renders_many :items` with `title:`, `open:`, `icon:` |
| **Button Group** | Groups buttons with shared border styling | -- |
| **Command Palette** | Cmd+K search overlay with grouped items | `placeholder:`, `items:` + `renders_one :trigger` |
| **Drawer** | Slide-out panel from left/right | `position:`, `size:` + trigger/header/footer slots |
| **Dropdown** | Dropdown menu with items and keyboard navigation | -- |
| **Empty State** | Placeholder for empty views | `title:`, `description:`, `size:` |
| **Modal** | Dialog overlay with header/footer slots | `id:` + trigger/header/footer slots |
| **Pagination** | Pagination with 4 variant types | -- |
| **Progress Steps** | Horizontal progress indicators | -- |
| **Stat** | Metric card with value, trend, change | `label:`, `value:`, `change:`, `trend:`, `period:`, `icon:` |
| **Stepper** | Multi-step wizard with navigation | `current_step:` + `renders_many :steps, :panels` |
| **Table** | Data table with sort, selection, bulk actions | `size:`, `selectable:`, `sortable:` + `renders_one :bulk_actions` |
| **Tabs** | Tab navigation with button/underline types | -- |
| **Timeline** | Vertical event feed with connector lines | `renders_many :items` with `title:`, `timestamp:`, `color:`, `icon:` |
| **Toast** | Auto-dismiss notification | `title:`, `description:`, `variant:`, `duration:`, `dismissible:` |

### Navigation Components

| Component | Description |
|-----------|-------------|
| **Breadcrumb** | Breadcrumb with chevron/slash separators and `current:` support |
| **Nav Sidebar** | Sidebar navigation with 5 variant types |
| **Nav Header** | Top header navigation bar |
| **Nav Item** | Navigation link with collapsible, icon, badge support |
| **Nav Account Card** | User account card with avatar and dropdown |

## Form Builder

Ergonomic form helpers that auto-populate names, values, labels, and validation errors:

```erb
<%= form_with model: @user, builder: UntitledUi::FormBuilder do |form| %>
  <%= form.ui_input :email, placeholder: "you@example.com" %>
  <%= form.ui_textarea :bio %>
  <%= form.ui_select :role, options: [["Admin", "admin"], ["Member", "member"]] %>
  <%= form.ui_checkbox :terms, label: "I agree to the terms" %>
  <%= form.ui_toggle :notifications %>
  <%= form.ui_radio_button :plan, value: "pro" %>
  <%= form.ui_button "Save" %>
<% end %>
```

## Design System

Visit `/design_system` to browse all components with:
- Live interactive examples
- Copy-to-clipboard code snippets
- **Playground** -- interactive controls to tweak component props in real-time (available for all components)
- **Theme switcher** -- dropdown to preview all installed themes
- **Dark mode toggle** -- switch between light and dark variants
- Alphabetically sorted sidebar with live search

## Themes

### Built-in Presets

Generate themes with curated color palettes:

```bash
rails generate untitled_ui:theme corporate --preset=corporate  # Indigo-blue
rails generate untitled_ui:theme ocean --preset=ocean          # Blue-teal
rails generate untitled_ui:theme warm --preset=warm            # Orange-earth
rails generate untitled_ui:theme dark --preset=dark            # Professional dark
```

Each preset automatically generates a dark variant (e.g., `dark_corporate.css`).

### Custom Themes

```bash
# Generate with placeholder colors to customize
rails generate untitled_ui:theme my_brand

# Generate a custom dark theme
rails generate untitled_ui:theme midnight --dark

# Combine a preset palette with dark mode
rails generate untitled_ui:theme dark_ocean --preset=ocean --dark
```

### Applying Themes

The generator creates the CSS file, adds the `@import`, and configures the initializer automatically.

```erb
<body class="ocean-theme">
```

Switch dynamically with JavaScript:

```javascript
document.body.className = 'ocean-theme';      // Light
document.body.className = 'dark_ocean-theme';  // Dark
document.body.className = '';                  // Default
```

### How Themes Work

Themes override CSS custom properties (brand, error, warning, success, gray color scales + semantic tokens) scoped under a CSS class. Dark themes also invert semantic tokens (dark backgrounds, light text, adjusted borders). All components automatically pick up theme colors through Tailwind's semantic token system.

## Generators

### Install

```bash
rails generate untitled_ui:install
```

### Theme

```bash
rails generate untitled_ui:theme NAME [--preset=PRESET] [--dark]
```

Available presets: `corporate`, `ocean`, `warm`, `dark`

### Component Scaffold

Scaffold a new component with all boilerplate:

```bash
# Basic component
rails generate untitled_ui:scaffold my_component

# With Stimulus controller
rails generate untitled_ui:scaffold my_component --stimulus

# With slots
rails generate untitled_ui:scaffold my_component --slots=header,footer

# With typed props
rails generate untitled_ui:scaffold my_component --props=size:select:sm:md:lg,disabled:boolean

# Full-featured
rails generate untitled_ui:scaffold notification \
  --stimulus \
  --slots=icon,actions \
  --props=variant:select:info:success:warning:error,dismissible:boolean,title:string
```

Generates: component.rb, component.html.erb, spec, design system example, and registers in the COMPONENTS array and index.js.

### Selective Component Installation

Copy specific components to your app for customization:

```bash
rails generate untitled_ui:component button modal
```

## Development

```bash
bundle install
bundle exec rspec           # Run all 509 specs
bundle exec rspec spec/components/ui/button_component_spec.rb  # Single component
```

## License

MIT
