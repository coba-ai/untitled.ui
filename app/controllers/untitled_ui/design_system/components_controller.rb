# frozen_string_literal: true

module UntitledUi
  module DesignSystem
    class ComponentsController < UntitledUi::ApplicationController
      layout "untitled_ui/design_system"

      COMPONENTS = [
        { id: "colors", name: "Colors", category: "Foundations",
          description: "The complete color palette including primary, secondary, and neutral scales." },
        { id: "alert", name: "Alert", category: "Base",
          description: "Persistent alert banner with info/success/warning/error variants and optional dismiss." },
        { id: "button", name: "Button", category: "Base",
          description: "Versatile button with multiple sizes, colors, icons, loading state, and polymorphic rendering." },
        { id: "badge", name: "Badge", category: "Base",
          description: "Status indicators with pill/badge types, 10 color variants, and optional dot/icon/dismiss." },
        { id: "input", name: "Input", category: "Base", description: "Text input with label, hint, icon, tooltip, and validation states." },
        { id: "textarea", name: "Textarea", category: "Base", description: "Multi-line text input with label, hint, and validation." },
        { id: "checkbox", name: "Checkbox", category: "Base", description: "Checkbox with visual indicator, label, hint, and indeterminate state." },
        { id: "toggle", name: "Toggle", category: "Base", description: "Toggle switch with track/thumb animation, label, and hint." },
        { id: "radio_button", name: "Radio Button", category: "Base", description: "Radio button with visual dot indicator, label, and hint." },
        { id: "avatar", name: "Avatar", category: "Base",
          description: "User avatar with image, initials, or placeholder fallback and status indicator." },
        { id: "label", name: "Label", category: "Base", description: "Form label with optional required asterisk and tooltip." },
        { id: "hint_text", name: "Hint Text", category: "Base", description: "Helper text for form fields with invalid state support." },
        { id: "tooltip", name: "Tooltip", category: "Base", description: "Tooltip with title, description, and configurable placement." },
        { id: "close_button", name: "Close Button", category: "Base",
          description: "Accessible close button with size variants and light/dark themes." },
        { id: "dot_icon", name: "Dot Icon", category: "Base", description: "Simple colored dot indicator." },
        { id: "featured_icon", name: "Featured Icon", category: "Base",
          description: "Icon container with light/dark/modern/outline themes and color variants." },
        { id: "progress_bar", name: "Progress Bar", category: "Base", description: "Progress bar with value, label, and percentage display." },
        { id: "loading_indicator", name: "Loading Indicator", category: "Base",
          description: "Animated spinner with line_simple and line_spinner types." },
        { id: "tabs", name: "Tabs", category: "Application", description: "Tab navigation with button_brand, button_gray, and underline types." },
        { id: "drawer", name: "Drawer", category: "Application",
          description: "Slide-out panel from left or right edge using HTML <dialog> with header/footer slots and size variants." },
        { id: "modal", name: "Modal", category: "Application", description: "Dialog overlay using HTML <dialog> with header/footer slots." },
        { id: "dropdown", name: "Dropdown", category: "Application", description: "Dropdown menu with items, icons, and keyboard navigation." },
        { id: "table", name: "Table", category: "Application",
          description: "Data table with sortable columns, header content slot, and size variants." },
        { id: "empty_state", name: "Empty State", category: "Application",
          description: "Placeholder content for empty views with icon and action slots." },
        { id: "button_group", name: "Button Group", category: "Application", description: "Groups buttons together with shared border styling." },
        { id: "nav_item", name: "Nav Item", category: "Navigation",
          description: "Base navigation link with collapsible, icon, badge, and active state support." },
        { id: "nav_sidebar", name: "Nav Sidebar", category: "Navigation",
          description: "Sidebar navigation with 5 variant types: simple, slim, dual_tier, section_dividers, section_subheadings." },
        { id: "nav_header", name: "Nav Header", category: "Navigation",
          description: "Top header navigation bar with horizontal items, secondary sub-nav, and avatar dropdown." },
        { id: "nav_account_card", name: "Nav Account Card", category: "Navigation",
          description: "User account card with avatar, name, email, and optional dropdown menu." },
        { id: "pagination", name: "Pagination", category: "Application",
          description: "Pagination with 4 variant types, ellipsis algorithm, and prev/next navigation." },
        { id: "card", name: "Card", category: "Base",
          description: "Content container with header, footer, and media slots. Configurable padding, shadow, and border." },
        { id: "progress_steps", name: "Progress Steps", category: "Application",
          description: "Horizontal progress steps with centered icons, connector lines, and completed/current/upcoming states." },
        { id: "breadcrumb", name: "Breadcrumb", category: "Navigation",
          description: "Breadcrumb navigation with chevron/slash separators and aria support." },
        { id: "stat", name: "Stat", category: "Application",
          description: "Metric display card with value, trend indicator, and change percentage." },
        { id: "file_upload", name: "File Upload", category: "Base",
          description: "Drag-and-drop file upload zone with click fallback, file type filtering, and size limits." },
        { id: "toast", name: "Toast", category: "Application",
          description: "Toast notification with success/error/warning/info variants, auto-dismiss, and stacking." },
        { id: "select", name: "Select", category: "Base",
          description: "Dropdown select with optional search filtering, keyboard navigation, and form builder integration." },
        { id: "date_picker", name: "Date Picker", category: "Base",
          description: "Calendar date picker with month navigation, range constraints, and input styling." },
        { id: "skeleton", name: "Skeleton", category: "Base",
          description: "Animated placeholder skeleton for loading states with text, circular, and rectangular variants." },
        { id: "timeline", name: "Timeline", category: "Application",
          description: "Vertical timeline with connector lines, colored dot/icon indicators, title, description, and timestamp per item." },
        { id: "accordion", name: "Accordion", category: "Application",
          description: "Collapsible accordion with single or multiple open items, animated height transitions, and chevron rotation." },
        { id: "tag_input", name: "Tag Input", category: "Base",
          description: "Tag input with pill-style tags, keyboard navigation, duplicate prevention, and max tag limit." },
        { id: "command_palette", name: "Command Palette", category: "Application",
          description: "Keyboard-driven command palette with Cmd+K shortcut, live filtering, grouped items, and keyboard navigation." },
        { id: "stepper", name: "Stepper", category: "Application",
          description: "Multi-step wizard with progress indicators, connector lines, content panels, and next/prev navigation." },
        { id: "color_picker", name: "Color Picker", category: "Base",
          description: "Color picker with preset swatches grid and hex input field for selecting colors." }
      ].freeze

      def index
        @components = COMPONENTS
        @categories = COMPONENTS.group_by { |c| c[:category] }
        @query = params[:q]

        return unless @query.present?

        @components = COMPONENTS.select do |c|
          c[:name].downcase.include?(@query.downcase) ||
            c[:description].downcase.include?(@query.downcase)
        end
        @categories = @components.group_by { |c| c[:category] }
      end

      def show
        @component = COMPONENTS.find { |c| c[:id] == params[:id] }
        redirect_to components_path, alert: "Component not found" unless @component
      end

      def playground
        @component = COMPONENTS.find { |c| c[:id] == params[:id] }
        return head(:not_found) unless @component

        config = UntitledUi::ComponentConfig.for(params[:id])
        return head(:not_found) unless config

        @props = UntitledUi::ComponentConfig.build_props(params[:id], params)
        @content = UntitledUi::ComponentConfig.build_content(params[:id], params)
        @code = UntitledUi::ComponentConfig.code_snippet(params[:id], @props, @content)
        @component_class = config[:component_class].constantize

        render partial: "untitled_ui/design_system/components/playground_preview", layout: false
      end
    end
  end
end
