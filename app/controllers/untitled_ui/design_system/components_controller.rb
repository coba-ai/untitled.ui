# frozen_string_literal: true

module UntitledUi
  module DesignSystem
    class ComponentsController < UntitledUi::ApplicationController
      layout "untitled_ui/design_system"

      COMPONENTS = [
        { id: "colors", name: "Colors", category: "Foundations", description: "The complete color palette including primary, secondary, and neutral scales." },
        { id: "button", name: "Button", category: "Base", description: "Versatile button with multiple sizes, colors, icons, loading state, and polymorphic rendering." },
        { id: "badge", name: "Badge", category: "Base", description: "Status indicators with pill/badge types, 10 color variants, and optional dot/icon/dismiss." },
        { id: "input", name: "Input", category: "Base", description: "Text input with label, hint, icon, tooltip, and validation states." },
        { id: "textarea", name: "Textarea", category: "Base", description: "Multi-line text input with label, hint, and validation." },
        { id: "checkbox", name: "Checkbox", category: "Base", description: "Checkbox with visual indicator, label, hint, and indeterminate state." },
        { id: "toggle", name: "Toggle", category: "Base", description: "Toggle switch with track/thumb animation, label, and hint." },
        { id: "radio_button", name: "Radio Button", category: "Base", description: "Radio button with visual dot indicator, label, and hint." },
        { id: "avatar", name: "Avatar", category: "Base", description: "User avatar with image, initials, or placeholder fallback and status indicator." },
        { id: "label", name: "Label", category: "Base", description: "Form label with optional required asterisk and tooltip." },
        { id: "hint_text", name: "Hint Text", category: "Base", description: "Helper text for form fields with invalid state support." },
        { id: "tooltip", name: "Tooltip", category: "Base", description: "Tooltip with title, description, and configurable placement." },
        { id: "close_button", name: "Close Button", category: "Base", description: "Accessible close button with size variants and light/dark themes." },
        { id: "dot_icon", name: "Dot Icon", category: "Base", description: "Simple colored dot indicator." },
        { id: "featured_icon", name: "Featured Icon", category: "Base", description: "Icon container with light/dark/modern/outline themes and color variants." },
        { id: "progress_bar", name: "Progress Bar", category: "Base", description: "Progress bar with value, label, and percentage display." },
        { id: "loading_indicator", name: "Loading Indicator", category: "Base", description: "Animated spinner with line_simple and line_spinner types." },
        { id: "tabs", name: "Tabs", category: "Application", description: "Tab navigation with button_brand, button_gray, and underline types." },
        { id: "modal", name: "Modal", category: "Application", description: "Dialog overlay using HTML <dialog> with header/footer slots." },
        { id: "dropdown", name: "Dropdown", category: "Application", description: "Dropdown menu with items, icons, and keyboard navigation." },
        { id: "table", name: "Table", category: "Application", description: "Data table with sortable columns, header content slot, and size variants." },
        { id: "empty_state", name: "Empty State", category: "Application", description: "Placeholder content for empty views with icon and action slots." },
        { id: "button_group", name: "Button Group", category: "Application", description: "Groups buttons together with shared border styling." },
        { id: "nav_item", name: "Nav Item", category: "Navigation", description: "Base navigation link with collapsible, icon, badge, and active state support." },
        { id: "nav_sidebar", name: "Nav Sidebar", category: "Navigation", description: "Sidebar navigation with 5 variant types: simple, slim, dual_tier, section_dividers, section_subheadings." },
        { id: "nav_header", name: "Nav Header", category: "Navigation", description: "Top header navigation bar with horizontal items, secondary sub-nav, and avatar dropdown." },
        { id: "nav_account_card", name: "Nav Account Card", category: "Navigation", description: "User account card with avatar, name, email, and optional dropdown menu." }
      ].freeze

      def index
        @components = COMPONENTS
        @categories = COMPONENTS.group_by { |c| c[:category] }
        @query = params[:q]

        if @query.present?
          @components = COMPONENTS.select do |c|
            c[:name].downcase.include?(@query.downcase) ||
              c[:description].downcase.include?(@query.downcase)
          end
          @categories = @components.group_by { |c| c[:category] }
        end
      end

      def show
        @component = COMPONENTS.find { |c| c[:id] == params[:id] }
        redirect_to design_system_components_path, alert: "Component not found" unless @component
      end
    end
  end
end
