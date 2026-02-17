# UntitledUi

A ViewComponent-based design system implementing Untitled UI tokens, components, and patterns for Rails applications with Tailwind CSS v4.

## Installation

Add the gem to your Gemfile:

```ruby
gem "untitled_ui", path: "../untitled_ui" # or from git/rubygems
```

Run the install generator:

```bash
rails generate untitled_ui:install
```

This will:
- Copy a brand color template to `app/assets/tailwind/untitled_ui_colors.css`
- Add CSS imports to your `application.css`
- Mount the design system at `/design_system`
- Register Stimulus controllers

## Usage

### Components

Use components in any view:

```erb
<%= render Ui::Button::Component.new(color: :primary, size: :md) { "Click me" } %>

<%= render Ui::Input::Component.new(label: "Email", placeholder: "you@example.com") %>

<%= render Ui::Badge::Component.new(color: :success) { "Active" } %>

<%= render Ui::Modal::Component.new do |modal| %>
  <% modal.with_trigger { "Open" } %>
  <% modal.with_header { "Modal Title" } %>
  Modal content here
<% end %>
```

### Available Components

**Base**: Button, Badge, Input, Textarea, Checkbox, Toggle, RadioButton, Avatar, Label, HintText, Tooltip, CloseButton, DotIcon, FeaturedIcon, ProgressBar, LoadingIndicator

**Application**: Tabs, Modal, Dropdown, Table, EmptyState, ButtonGroup

### Design System Browser

Visit `/design_system` to browse all components with live examples.

### Customizing Colors

Edit `app/assets/tailwind/untitled_ui_colors.css` to customize your brand palette. The Untitled UI token system will automatically cascade your brand colors through all semantic tokens.

## Development

```bash
bundle install
bundle exec rspec
```

## License

MIT
