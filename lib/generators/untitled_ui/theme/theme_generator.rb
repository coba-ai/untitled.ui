# frozen_string_literal: true

require "fileutils"
require "pathname"

module UntitledUi
  module Generators
    class ThemeGenerator < Rails::Generators::Base
      desc "Generate a custom UntitledUi theme CSS file with color overrides"

      argument :theme_name, type: :string, desc: "Name of the theme (e.g. corporate, ocean)"

      class_option :preset, type: :string, default: nil,
        desc: "Use a color preset: corporate, ocean, warm, or dark"

      class_option :dark, type: :boolean, default: false,
        desc: "Generate with inverted semantic tokens for dark backgrounds"

      PRESETS = {
        "corporate" => {
          brand: {
            25 => "rgb(245 247 255)", 50 => "rgb(237 240 254)", 100 => "rgb(221 226 253)",
            200 => "rgb(196 205 251)", 300 => "rgb(160 174 247)", 400 => "rgb(118 137 242)",
            500 => "rgb(79 99 235)", 600 => "rgb(55 65 199)", 700 => "rgb(45 52 163)",
            800 => "rgb(38 44 130)", 900 => "rgb(34 40 104)", 950 => "rgb(22 26 72)"
          },
          error: {
            25 => "rgb(255 251 250)", 50 => "rgb(254 243 242)", 100 => "rgb(254 228 226)",
            200 => "rgb(254 205 202)", 300 => "rgb(253 162 155)", 400 => "rgb(249 112 102)",
            500 => "rgb(240 68 56)", 600 => "rgb(217 45 32)", 700 => "rgb(180 35 24)",
            800 => "rgb(145 32 24)", 900 => "rgb(122 39 26)", 950 => "rgb(85 22 12)"
          },
          warning: {
            25 => "rgb(255 252 245)", 50 => "rgb(255 250 235)", 100 => "rgb(254 240 199)",
            200 => "rgb(254 223 137)", 300 => "rgb(254 200 75)", 400 => "rgb(253 176 34)",
            500 => "rgb(247 144 9)", 600 => "rgb(220 104 3)", 700 => "rgb(181 71 8)",
            800 => "rgb(147 55 13)", 900 => "rgb(122 46 14)", 950 => "rgb(78 29 9)"
          },
          success: {
            25 => "rgb(246 254 249)", 50 => "rgb(236 253 243)", 100 => "rgb(220 250 230)",
            200 => "rgb(171 239 198)", 300 => "rgb(117 224 167)", 400 => "rgb(71 205 137)",
            500 => "rgb(23 178 106)", 600 => "rgb(7 148 85)", 700 => "rgb(6 118 71)",
            800 => "rgb(8 93 58)", 900 => "rgb(7 77 49)", 950 => "rgb(5 51 33)"
          },
          gray: {
            25 => "rgb(252 252 253)", 50 => "rgb(248 249 252)", 100 => "rgb(234 236 245)",
            200 => "rgb(213 217 235)", 300 => "rgb(179 184 219)", 400 => "rgb(113 123 188)",
            500 => "rgb(78 91 166)", 600 => "rgb(62 71 132)", 700 => "rgb(54 63 114)",
            800 => "rgb(41 48 86)", 900 => "rgb(16 19 35)", 950 => "rgb(13 15 28)"
          }
        },
        "ocean" => {
          brand: {
            25 => "rgb(245 251 255)", 50 => "rgb(240 249 255)", 100 => "rgb(224 242 254)",
            200 => "rgb(185 230 254)", 300 => "rgb(124 212 253)", 400 => "rgb(54 191 250)",
            500 => "rgb(11 165 236)", 600 => "rgb(0 134 201)", 700 => "rgb(2 106 162)",
            800 => "rgb(6 89 134)", 900 => "rgb(11 74 111)", 950 => "rgb(6 44 65)"
          },
          error: {
            25 => "rgb(255 245 246)", 50 => "rgb(255 241 243)", 100 => "rgb(255 228 232)",
            200 => "rgb(254 205 214)", 300 => "rgb(254 163 180)", 400 => "rgb(253 111 142)",
            500 => "rgb(246 61 104)", 600 => "rgb(227 27 84)", 700 => "rgb(192 16 72)",
            800 => "rgb(161 16 67)", 900 => "rgb(137 18 62)", 950 => "rgb(81 11 36)"
          },
          warning: {
            25 => "rgb(255 252 245)", 50 => "rgb(255 250 235)", 100 => "rgb(254 240 199)",
            200 => "rgb(254 223 137)", 300 => "rgb(254 200 75)", 400 => "rgb(253 176 34)",
            500 => "rgb(247 144 9)", 600 => "rgb(220 104 3)", 700 => "rgb(181 71 8)",
            800 => "rgb(147 55 13)", 900 => "rgb(122 46 14)", 950 => "rgb(78 29 9)"
          },
          success: {
            25 => "rgb(246 254 252)", 50 => "rgb(240 253 249)", 100 => "rgb(204 251 239)",
            200 => "rgb(153 246 224)", 300 => "rgb(95 233 208)", 400 => "rgb(46 211 183)",
            500 => "rgb(21 183 158)", 600 => "rgb(14 147 132)", 700 => "rgb(16 117 105)",
            800 => "rgb(18 93 86)", 900 => "rgb(19 78 72)", 950 => "rgb(10 41 38)"
          },
          gray: {
            25 => "rgb(252 253 253)", 50 => "rgb(248 250 252)", 100 => "rgb(238 242 246)",
            200 => "rgb(227 232 239)", 300 => "rgb(205 213 223)", 400 => "rgb(154 164 178)",
            500 => "rgb(105 117 134)", 600 => "rgb(75 85 101)", 700 => "rgb(54 65 82)",
            800 => "rgb(32 41 57)", 900 => "rgb(18 25 38)", 950 => "rgb(13 18 28)"
          }
        },
        "warm" => {
          brand: {
            25 => "rgb(255 249 245)", 50 => "rgb(255 244 237)", 100 => "rgb(255 230 213)",
            200 => "rgb(255 214 174)", 300 => "rgb(255 156 102)", 400 => "rgb(255 105 46)",
            500 => "rgb(239 104 32)", 600 => "rgb(224 79 22)", 700 => "rgb(185 56 21)",
            800 => "rgb(147 47 25)", 900 => "rgb(119 41 23)", 950 => "rgb(81 28 16)"
          },
          error: {
            25 => "rgb(255 251 250)", 50 => "rgb(254 243 242)", 100 => "rgb(254 228 226)",
            200 => "rgb(254 205 202)", 300 => "rgb(253 162 155)", 400 => "rgb(249 112 102)",
            500 => "rgb(240 68 56)", 600 => "rgb(217 45 32)", 700 => "rgb(180 35 24)",
            800 => "rgb(145 32 24)", 900 => "rgb(122 39 26)", 950 => "rgb(85 22 12)"
          },
          warning: {
            25 => "rgb(254 253 240)", 50 => "rgb(254 251 232)", 100 => "rgb(254 247 195)",
            200 => "rgb(254 238 149)", 300 => "rgb(253 226 114)", 400 => "rgb(250 197 21)",
            500 => "rgb(234 170 8)", 600 => "rgb(202 133 4)", 700 => "rgb(161 92 7)",
            800 => "rgb(133 74 14)", 900 => "rgb(113 59 18)", 950 => "rgb(84 44 13)"
          },
          success: {
            25 => "rgb(250 253 247)", 50 => "rgb(245 251 238)", 100 => "rgb(230 244 215)",
            200 => "rgb(206 234 176)", 300 => "rgb(172 220 121)", 400 => "rgb(134 203 60)",
            500 => "rgb(102 159 42)", 600 => "rgb(79 122 33)", 700 => "rgb(63 98 26)",
            800 => "rgb(51 80 21)", 900 => "rgb(43 66 18)", 950 => "rgb(26 40 11)"
          },
          gray: {
            25 => "rgb(253 253 252)", 50 => "rgb(250 250 249)", 100 => "rgb(245 245 244)",
            200 => "rgb(231 229 228)", 300 => "rgb(215 211 208)", 400 => "rgb(169 162 157)",
            500 => "rgb(121 113 107)", 600 => "rgb(87 83 78)", 700 => "rgb(68 64 60)",
            800 => "rgb(41 37 36)", 900 => "rgb(28 25 23)", 950 => "rgb(23 20 18)"
          }
        },
        "dark" => {
          brand: {
            25 => "rgb(240 249 255)", 50 => "rgb(224 242 254)", 100 => "rgb(186 230 253)",
            200 => "rgb(125 211 252)", 300 => "rgb(56 189 248)", 400 => "rgb(14 165 233)",
            500 => "rgb(2 132 199)", 600 => "rgb(3 105 161)", 700 => "rgb(7 89 133)",
            800 => "rgb(12 74 110)", 900 => "rgb(8 51 78)", 950 => "rgb(5 33 52)"
          },
          error: {
            25 => "rgb(255 245 245)", 50 => "rgb(254 228 226)", 100 => "rgb(254 205 202)",
            200 => "rgb(252 165 163)", 300 => "rgb(252 107 105)", 400 => "rgb(248 66 64)",
            500 => "rgb(229 47 47)", 600 => "rgb(195 28 28)", 700 => "rgb(154 18 18)",
            800 => "rgb(120 12 12)", 900 => "rgb(95 10 10)", 950 => "rgb(67 7 7)"
          },
          warning: {
            25 => "rgb(255 252 235)", 50 => "rgb(254 243 199)", 100 => "rgb(253 230 138)",
            200 => "rgb(252 211 77)", 300 => "rgb(251 191 36)", 400 => "rgb(245 158 11)",
            500 => "rgb(217 119 6)", 600 => "rgb(180 83 9)", 700 => "rgb(146 64 14)",
            800 => "rgb(120 53 15)", 900 => "rgb(98 44 16)", 950 => "rgb(69 31 11)"
          },
          success: {
            25 => "rgb(240 253 244)", 50 => "rgb(220 252 231)", 100 => "rgb(187 247 208)",
            200 => "rgb(134 239 172)", 300 => "rgb(74 222 128)", 400 => "rgb(34 197 94)",
            500 => "rgb(22 163 74)", 600 => "rgb(21 128 61)", 700 => "rgb(20 83 45)",
            800 => "rgb(15 64 35)", 900 => "rgb(14 55 31)", 950 => "rgb(9 37 21)"
          },
          gray: {
            25 => "rgb(248 250 252)", 50 => "rgb(241 245 249)", 100 => "rgb(226 232 240)",
            200 => "rgb(203 213 225)", 300 => "rgb(148 163 184)", 400 => "rgb(100 116 139)",
            500 => "rgb(71 85 105)", 600 => "rgb(51 65 85)", 700 => "rgb(30 41 59)",
            800 => "rgb(15 23 42)", 900 => "rgb(8 15 31)", 950 => "rgb(3 7 18)"
          }
        }
      }.freeze

      AVAILABLE_PRESETS = PRESETS.keys.freeze

      def validate_preset
        return if options[:preset].nil?
        return if AVAILABLE_PRESETS.include?(options[:preset])

        say_status :error, "Unknown preset '#{options[:preset]}'. Available presets: #{AVAILABLE_PRESETS.join(', ')}", :red
        raise Thor::Error, "Unknown preset: #{options[:preset]}"
      end

      def create_theme_css
        css_path = File.join(destination_root, "app/assets/tailwind/untitled_ui/#{theme_name}.css")
        FileUtils.mkdir_p(File.dirname(css_path))

        content = generate_theme_css
        File.write(css_path, content)
        say_status :create, "app/assets/tailwind/untitled_ui/#{theme_name}.css", :green
      end

      def add_css_import
        css_file = Pathname.new(File.join(destination_root, "app/assets/tailwind/application.css"))
        return unless css_file.exist?

        import_line = "@import \"./untitled_ui/#{theme_name}.css\";"
        content = css_file.read
        return if content.include?(import_line)

        updated = "#{content.rstrip}\n#{import_line}\n"
        css_file.write(updated)
        say_status :insert, "app/assets/tailwind/application.css", :green
      end

      def configure_theme
        initializer_path = File.join(destination_root, "config/initializers/untitled_ui.rb")

        if File.exist?(initializer_path)
          content = File.read(initializer_path)
          if content.include?("config.theme")
            content.gsub!(/config\.theme\s*=\s*:\w+/, "config.theme = :#{theme_name}")
            File.write(initializer_path, content)
            say_status :update, "config/initializers/untitled_ui.rb", :green
          else
            inject_into_file initializer_path, "  config.theme = :#{theme_name}\n", after: /configure do \|config\|\n/
          end
        else
          create_file "config/initializers/untitled_ui.rb", <<~RUBY
            UntitledUi.configure do |config|
              config.theme = :#{theme_name}
            end
          RUBY
        end
      end

      def show_instructions
        say ""
        say "Theme '#{theme_name}' generated successfully!", :green
        say ""
        say "To apply this theme, add the CSS class to your <body> tag:"
        say "  <body class=\"#{theme_name}-theme\">"
        say ""
        if options[:preset]
          say "Preset '#{options[:preset]}' has been applied with curated color values."
          say "You can further customize the colors in:"
        else
          say "Customize the placeholder color values in:"
        end
        say "  app/assets/tailwind/untitled_ui/#{theme_name}.css"
        say ""
        say "To switch themes dynamically with JavaScript:"
        say "  document.body.className = '#{theme_name}-theme';"
        say ""
      end

      private

      def generate_theme_css
        preset = options[:preset] ? PRESETS[options[:preset]] : nil
        dark_mode = options[:dark] || options[:preset] == "dark"
        sanitized_name = theme_name.gsub(/[^a-zA-Z0-9_-]/, "-")

        <<~CSS
          /* ============================================
             Untitled UI — #{sanitized_name.capitalize} Theme
             Activated by adding .#{sanitized_name}-theme to <body>
             Generated with: rails generate untitled_ui:theme #{theme_name}#{options[:preset] ? " --preset=#{options[:preset]}" : ""}
             ============================================ */

          .#{sanitized_name}-theme {

              /* ----------------------------------------
                 BRAND COLORS
                 Your primary brand color palette.
                 These cascade into buttons, links, focus
                 rings, and all branded UI elements.
                 ---------------------------------------- */
          #{color_scale("brand", preset)}

              /* ----------------------------------------
                 ERROR COLORS
                 Used for destructive actions, form
                 validation errors, and error alerts.
                 ---------------------------------------- */
          #{color_scale("error", preset)}

              /* ----------------------------------------
                 WARNING COLORS
                 Used for caution states, pending actions,
                 and warning notifications.
                 ---------------------------------------- */
          #{color_scale("warning", preset)}

              /* ----------------------------------------
                 SUCCESS COLORS
                 Used for positive feedback, completed
                 actions, and success notifications.
                 ---------------------------------------- */
          #{color_scale("success", preset)}

              /* ----------------------------------------
                 GRAY COLORS
                 The neutral palette used for text,
                 backgrounds, borders, and disabled states.
                 Changing these significantly alters the
                 overall look and feel.
                 ---------------------------------------- */
          #{color_scale("gray", preset)}

              /* ----------------------------------------
                 TEXT COLORS
                 Semantic text color tokens. These reference
                 the scales above. Override only if you need
                 fine-grained control beyond changing the
                 base color scales.
                 ---------------------------------------- */
              --color-text-primary: #{dark_mode ? "var(--color-gray-50)" : "var(--color-gray-900)"};
              --color-text-secondary: #{dark_mode ? "var(--color-gray-300)" : "var(--color-gray-700)"};
              --color-text-secondary_hover: #{dark_mode ? "var(--color-gray-200)" : "var(--color-gray-800)"};
              --color-text-tertiary: #{dark_mode ? "var(--color-gray-400)" : "var(--color-gray-600)"};
              --color-text-tertiary_hover: #{dark_mode ? "var(--color-gray-300)" : "var(--color-gray-700)"};
              --color-text-quaternary: var(--color-gray-500);
              --color-text-disabled: var(--color-gray-500);
              --color-text-placeholder: var(--color-gray-500);
              --color-text-placeholder_subtle: #{dark_mode ? "var(--color-gray-600)" : "var(--color-gray-300)"};
              --color-text-brand-primary: #{dark_mode ? "var(--color-brand-300)" : "var(--color-brand-900)"};
              --color-text-brand-secondary: #{dark_mode ? "var(--color-brand-400)" : "var(--color-brand-700)"};
              --color-text-brand-secondary_hover: #{dark_mode ? "var(--color-brand-300)" : "var(--color-brand-800)"};
              --color-text-brand-tertiary: #{dark_mode ? "var(--color-brand-400)" : "var(--color-brand-600)"};
              --color-text-brand-tertiary_alt: #{dark_mode ? "var(--color-brand-400)" : "var(--color-brand-600)"};
              --color-text-error-primary: #{dark_mode ? "var(--color-error-400)" : "var(--color-error-600)"};
              --color-text-warning-primary: #{dark_mode ? "var(--color-warning-400)" : "var(--color-warning-600)"};
              --color-text-success-primary: #{dark_mode ? "var(--color-success-400)" : "var(--color-success-600)"};

              /* ----------------------------------------
                 BORDER COLORS
                 Borders, dividers, and separators.
                 ---------------------------------------- */
              --color-border-primary: #{dark_mode ? "var(--color-gray-700)" : "var(--color-gray-300)"};
              --color-border-secondary: #{dark_mode ? "var(--color-gray-800)" : "var(--color-gray-200)"};
              --color-border-tertiary: #{dark_mode ? "var(--color-gray-800)" : "var(--color-gray-100)"};
              --color-border-brand: #{dark_mode ? "var(--color-brand-400)" : "var(--color-brand-500)"};
              --color-border-brand_alt: #{dark_mode ? "var(--color-gray-700)" : "var(--color-brand-600)"};
              --color-border-error: #{dark_mode ? "var(--color-error-400)" : "var(--color-error-500)"};
              --color-border-disabled: #{dark_mode ? "var(--color-gray-700)" : "var(--color-gray-300)"};

              /* ----------------------------------------
                 FOREGROUND COLORS
                 Icons and foreground decorative elements.
                 ---------------------------------------- */
              --color-fg-primary: #{dark_mode ? "var(--color-gray-100)" : "var(--color-gray-900)"};
              --color-fg-secondary: #{dark_mode ? "var(--color-gray-300)" : "var(--color-gray-700)"};
              --color-fg-secondary_hover: #{dark_mode ? "var(--color-gray-200)" : "var(--color-gray-800)"};
              --color-fg-tertiary: #{dark_mode ? "var(--color-gray-400)" : "var(--color-gray-600)"};
              --color-fg-quaternary: var(--color-gray-400);
              --color-fg-brand-primary: #{dark_mode ? "var(--color-brand-400)" : "var(--color-brand-600)"};
              --color-fg-brand-secondary: #{dark_mode ? "var(--color-brand-400)" : "var(--color-brand-500)"};
              --color-fg-disabled: var(--color-gray-400);
              --color-fg-error-primary: #{dark_mode ? "var(--color-error-400)" : "var(--color-error-600)"};
              --color-fg-warning-primary: #{dark_mode ? "var(--color-warning-400)" : "var(--color-warning-600)"};
              --color-fg-success-primary: #{dark_mode ? "var(--color-success-400)" : "var(--color-success-600)"};

              /* ----------------------------------------
                 BACKGROUND COLORS
                 Surface and container backgrounds.
                 ---------------------------------------- */
              --color-bg-primary: #{dark_mode ? "var(--color-gray-950)" : "var(--color-white)"};
              --color-bg-primary_hover: #{dark_mode ? "var(--color-gray-800)" : "var(--color-gray-50)"};
              --color-bg-secondary: #{dark_mode ? "var(--color-gray-900)" : "var(--color-gray-50)"};
              --color-bg-secondary_hover: #{dark_mode ? "var(--color-gray-800)" : "var(--color-gray-100)"};
              --color-bg-tertiary: #{dark_mode ? "var(--color-gray-800)" : "var(--color-gray-100)"};
              --color-bg-quaternary: #{dark_mode ? "var(--color-gray-700)" : "var(--color-gray-200)"};
              --color-bg-brand-primary: #{dark_mode ? "var(--color-brand-950)" : "var(--color-brand-50)"};
              --color-bg-brand-solid: var(--color-brand-600);
              --color-bg-brand-solid_hover: #{dark_mode ? "var(--color-brand-500)" : "var(--color-brand-700)"};
              --color-bg-brand-section: #{dark_mode ? "var(--color-gray-900)" : "var(--color-brand-800)"};
              --color-bg-error-primary: #{dark_mode ? "var(--color-error-950)" : "var(--color-error-50)"};
              --color-bg-error-solid: var(--color-error-600);
              --color-bg-warning-primary: #{dark_mode ? "var(--color-warning-950)" : "var(--color-warning-50)"};
              --color-bg-warning-solid: var(--color-warning-600);
              --color-bg-success-primary: #{dark_mode ? "var(--color-success-950)" : "var(--color-success-50)"};
              --color-bg-success-solid: var(--color-success-600);
              --color-bg-disabled: #{dark_mode ? "var(--color-gray-800)" : "var(--color-gray-100)"};
            --color-bg-active: #{dark_mode ? "var(--color-gray-800)" : "var(--color-gray-50)"};

              /* ----------------------------------------
                 TAILWIND V4 INTERNAL MAPPINGS
                 These bridge semantic tokens to Tailwind's
                 internal utility variables. Required for
                 theme overrides to take effect.
                 ---------------------------------------- */
              --background-color-primary: var(--color-bg-primary);
              --background-color-primary_hover: var(--color-bg-primary_hover);
              --background-color-secondary: var(--color-bg-secondary);
              --background-color-secondary_hover: var(--color-bg-secondary_hover);
              --background-color-tertiary: var(--color-bg-tertiary);
              --background-color-quaternary: var(--color-bg-quaternary);
              --background-color-brand-primary: var(--color-bg-brand-primary);
              --background-color-brand-solid: var(--color-bg-brand-solid);
              --background-color-brand-solid_hover: var(--color-bg-brand-solid_hover);
              --background-color-brand-section: var(--color-bg-brand-section);
              --background-color-error-primary: var(--color-bg-error-primary);
              --background-color-error-solid: var(--color-bg-error-solid);
              --background-color-warning-primary: var(--color-bg-warning-primary);
              --background-color-warning-solid: var(--color-bg-warning-solid);
              --background-color-success-primary: var(--color-bg-success-primary);
              --background-color-success-solid: var(--color-bg-success-solid);
              --background-color-disabled: var(--color-bg-disabled);
              --background-color-active: var(--color-bg-active);
              --text-color-primary: var(--color-text-primary);
              --text-color-secondary: var(--color-text-secondary);
              --text-color-secondary_hover: var(--color-text-secondary_hover);
              --text-color-tertiary: var(--color-text-tertiary);
              --text-color-tertiary_hover: var(--color-text-tertiary_hover);
              --text-color-quaternary: var(--color-text-quaternary);
              --text-color-disabled: var(--color-text-disabled);
              --text-color-placeholder: var(--color-text-placeholder);
              --text-color-brand-primary: var(--color-text-brand-primary);
              --text-color-brand-secondary: var(--color-text-brand-secondary);
              --text-color-brand-secondary_hover: var(--color-text-brand-secondary_hover);
              --text-color-brand-tertiary: var(--color-text-brand-tertiary);
              --text-color-error-primary: var(--color-text-error-primary);
              --text-color-warning-primary: var(--color-text-warning-primary);
              --text-color-success-primary: var(--color-text-success-primary);
              --border-color-primary: var(--color-border-primary);
              --border-color-secondary: var(--color-border-secondary);
              --border-color-tertiary: var(--color-border-tertiary);
              --border-color-brand: var(--color-border-brand);
              --border-color-brand_alt: var(--color-border-brand_alt);
              --border-color-brand-solid: var(--color-bg-brand-solid);
              --border-color-brand-solid_hover: var(--color-bg-brand-solid_hover);
              --border-color-error: var(--color-border-error);
              --border-color-disabled: var(--color-border-disabled);
              --ring-color-primary: var(--color-border-primary);
              --ring-color-secondary: var(--color-border-secondary);
              --ring-color-tertiary: var(--color-border-tertiary);
              --ring-color-brand: var(--color-border-brand);
              --ring-color-brand-solid: var(--color-bg-brand-solid);
              --ring-color-brand-solid_hover: var(--color-bg-brand-solid_hover);
              --ring-color-error: var(--color-border-error);
              --ring-color-disabled: var(--color-border-disabled);
              --outline-color-brand: var(--color-border-brand);
              --outline-color-error: var(--color-border-error);
          }
        CSS
      end

      def color_scale(name, preset)
        steps = [25, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950]
        lines = steps.map do |step|
          value = if preset && preset[name.to_sym]
                    preset[name.to_sym][step]
                  else
                    "rgb(0 0 0) /* TODO: customize */"
                  end
          "        --color-#{name}-#{step}: #{value};"
        end
        lines.join("\n")
      end
    end
  end
end
