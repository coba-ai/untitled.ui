# frozen_string_literal: true

require "rails_helper"
require "fileutils"
require "tmpdir"
require "rails/generators"
require "generators/untitled_ui/scaffold/scaffold_generator"

RSpec.describe UntitledUi::Generators::ScaffoldGenerator do
  def prepare_minimal_app!(root)
    # Create a minimal components_controller.rb for registration tests
    FileUtils.mkdir_p(File.join(root, "app/controllers/untitled_ui/design_system"))
    File.write(
      File.join(root, "app/controllers/untitled_ui/design_system/components_controller.rb"),
      <<~RUBY
        # frozen_string_literal: true

        module UntitledUi
          module DesignSystem
            class ComponentsController < UntitledUi::ApplicationController
              COMPONENTS = [
                { id: "badge", name: "Badge", category: "Base", description: "Badge component." }
              ].freeze
            end
          end
        end
      RUBY
    )

    FileUtils.mkdir_p(File.join(root, "app/javascript/untitled_ui"))
    File.write(
      File.join(root, "app/javascript/untitled_ui/index.js"),
      <<~JS
        import { Application } from "@hotwired/stimulus"

        import ToggleController from "untitled_ui/toggle_controller"

        const controllerDefinitions = [
          ["toggle", ToggleController]
        ]

        const application = window.Stimulus || Application.start()
        window.Stimulus = application

        controllerDefinitions.forEach(([identifier, controller]) => {
          application.register(identifier, controller)
        })

        export {
          application,
          ToggleController
        }
      JS
    )
  end

  def run_generator!(root, name, options = {})
    generator = described_class.new([name], options, {})
    generator.destination_root = root
    generator.invoke_all
  end

  describe "basic file generation" do
    it "creates the component Ruby file" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "my_widget")

        path = File.join(root, "app/components/ui/my_widget/component.rb")
        expect(File.exist?(path)).to be(true)

        content = File.read(path)
        expect(content).to include("module Ui")
        expect(content).to include("module MyWidget")
        expect(content).to include("class Component < Ui::Base")
        expect(content).to include("attr_reader :extra_classes")
        expect(content).to include("def initialize(class: nil, **_opts)")
        expect(content).to include("binding.local_variable_get(:class)")
        expect(content).to include("def root_classes")
        expect(content).to include("cx(")
      end
    end

    it "creates the component ERB template" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "my_widget")

        path = File.join(root, "app/components/ui/my_widget/component.html.erb")
        expect(File.exist?(path)).to be(true)

        content = File.read(path)
        expect(content).to include("root_classes")
        expect(content).to include("<div")
      end
    end

    it "creates the RSpec spec file" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "my_widget")

        path = File.join(root, "spec/components/ui/my_widget_component_spec.rb")
        expect(File.exist?(path)).to be(true)

        content = File.read(path)
        expect(content).to include("Ui::MyWidget::Component")
        expect(content).to include("type: :component")
        expect(content).to include("renders with default props")
        expect(content).to include("accepts extra CSS classes")
      end
    end

    it "creates the design system example partial" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "my_widget")

        path = File.join(
          root,
          "app/views/untitled_ui/design_system/components/examples/_my_widget.html.erb"
        )
        expect(File.exist?(path)).to be(true)

        content = File.read(path)
        expect(content).to include("example_section")
        expect(content).to include("code_block")
        expect(content).to include("Ui::MyWidget::Component")
      end
    end

    it "registers the component in the components controller" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "my_widget")

        controller = File.read(
          File.join(root, "app/controllers/untitled_ui/design_system/components_controller.rb")
        )
        expect(controller).to include("id: \"my_widget\"")
        expect(controller).to include("name: \"My Widget\"")
        expect(controller).to include("category: \"Base\"")
      end
    end

    it "does not duplicate registration when run twice" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "my_widget")
        run_generator!(root, "my_widget")

        controller = File.read(
          File.join(root, "app/controllers/untitled_ui/design_system/components_controller.rb")
        )
        expect(controller.scan("id: \"my_widget\"").length).to eq(1)
      end
    end

    it "handles multi-word component names correctly" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "stat_card")

        rb_path = File.join(root, "app/components/ui/stat_card/component.rb")
        expect(File.exist?(rb_path)).to be(true)

        content = File.read(rb_path)
        expect(content).to include("module StatCard")
        expect(content).to include("class Component < Ui::Base")
      end
    end
  end

  describe "--slots option" do
    it "adds renders_one declarations for each slot" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "card", slots: "header,footer")

        content = File.read(File.join(root, "app/components/ui/card/component.rb"))
        expect(content).to include("renders_one :header")
        expect(content).to include("renders_one :footer")
      end
    end

    it "adds slot rendering to the ERB template" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "card", slots: "header,footer")

        content = File.read(File.join(root, "app/components/ui/card/component.html.erb"))
        expect(content).to include("header")
        expect(content).to include("footer")
      end
    end

    it "works with a single slot" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "panel", slots: "title")

        content = File.read(File.join(root, "app/components/ui/panel/component.rb"))
        expect(content).to include("renders_one :title")
        expect(content).not_to include("renders_one :footer")
      end
    end
  end

  describe "--props option" do
    it "adds boolean props with false defaults" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "toggle_chip", props: "disabled:boolean,checked:boolean")

        content = File.read(File.join(root, "app/components/ui/toggle_chip/component.rb"))
        expect(content).to include("disabled: false")
        expect(content).to include("checked: false")
        expect(content).to include("@disabled = disabled")
        expect(content).to include("@checked = checked")
      end
    end

    it "adds select props with first value as default" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "size_box", props: "size:select:sm:md:lg")

        content = File.read(File.join(root, "app/components/ui/size_box/component.rb"))
        expect(content).to include("size: :sm")
        expect(content).to include("@size = size.to_sym")
        expect(content).to include("SIZE_OPTIONS = %i[sm md lg]")
      end
    end

    it "adds string props with nil defaults" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "labeled_item", props: "label:string,description:string")

        content = File.read(File.join(root, "app/components/ui/labeled_item/component.rb"))
        expect(content).to include("label: nil")
        expect(content).to include("description: nil")
        expect(content).to include("@label = label")
        expect(content).to include("@description = description")
      end
    end

    it "includes prop names in attr_reader" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "chip", props: "size:select:sm:md:lg,disabled:boolean")

        content = File.read(File.join(root, "app/components/ui/chip/component.rb"))
        expect(content).to include("attr_reader :size, :disabled, :extra_classes")
      end
    end

    it "generates spec with select prop variant tests" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "color_dot", props: "color:select:red:green:blue")

        spec = File.read(File.join(root, "spec/components/ui/color_dot_component_spec.rb"))
        expect(spec).to include("COLOR_OPTIONS")
        expect(spec).to include("color variants")
      end
    end

    it "handles mixed prop types" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "alert_box",
                        props: "variant:select:info:warning:error,dismissible:boolean,title:string")

        content = File.read(File.join(root, "app/components/ui/alert_box/component.rb"))
        expect(content).to include("variant: :info")
        expect(content).to include("dismissible: false")
        expect(content).to include("title: nil")
        expect(content).to include("VARIANT_OPTIONS = %i[info warning error]")
      end
    end
  end

  describe "--stimulus option" do
    it "generates a Stimulus controller file" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "dropdown_menu", stimulus: true)

        path = File.join(root, "app/javascript/untitled_ui/dropdown_menu_controller.js")
        expect(File.exist?(path)).to be(true)

        content = File.read(path)
        expect(content).to include("import { Controller } from \"@hotwired/stimulus\"")
        expect(content).to include("export default class extends Controller")
        expect(content).to include("connect()")
      end
    end

    it "registers the Stimulus controller in index.js" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "dropdown_menu", stimulus: true)

        index = File.read(File.join(root, "app/javascript/untitled_ui/index.js"))
        expect(index).to include("import DropdownMenuController")
        expect(index).to include("dropdown_menu_controller")
      end
    end

    it "does not generate a Stimulus controller without --stimulus flag" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "simple_card")

        path = File.join(root, "app/javascript/untitled_ui/simple_card_controller.js")
        expect(File.exist?(path)).to be(false)
      end
    end

    it "does not duplicate stimulus registration when run twice" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "my_thing", stimulus: true)
        run_generator!(root, "my_thing", stimulus: true)

        index = File.read(File.join(root, "app/javascript/untitled_ui/index.js"))
        expect(index.scan("import MyThingController").length).to eq(1)
      end
    end

    it "skips stimulus registration when index.js does not exist" do
      Dir.mktmpdir do |root|
        # No index.js setup
        FileUtils.mkdir_p(File.join(root, "app/controllers/untitled_ui/design_system"))
        File.write(
          File.join(root, "app/controllers/untitled_ui/design_system/components_controller.rb"),
          <<~RUBY
            module UntitledUi
              module DesignSystem
                class ComponentsController
                  COMPONENTS = [].freeze
                end
              end
            end
          RUBY
        )

        expect { run_generator!(root, "ghost", stimulus: true) }.not_to raise_error
      end
    end
  end

  describe "combined options" do
    it "generates all files with slots, props, and stimulus together" do
      Dir.mktmpdir do |root|
        prepare_minimal_app!(root)
        run_generator!(root, "notification",
                        stimulus: true,
                        slots: "icon,actions",
                        props: "variant:select:info:success:warning,dismissible:boolean,title:string")

        # Component Ruby file
        rb = File.read(File.join(root, "app/components/ui/notification/component.rb"))
        expect(rb).to include("renders_one :icon")
        expect(rb).to include("renders_one :actions")
        expect(rb).to include("variant: :info")
        expect(rb).to include("dismissible: false")
        expect(rb).to include("title: nil")
        expect(rb).to include("VARIANT_OPTIONS")

        # ERB template
        erb = File.read(File.join(root, "app/components/ui/notification/component.html.erb"))
        expect(erb).to include("root_classes")

        # Spec
        spec = File.read(File.join(root, "spec/components/ui/notification_component_spec.rb"))
        expect(spec).to include("Ui::Notification::Component")

        # Design system example
        example = File.read(
          File.join(root,
                    "app/views/untitled_ui/design_system/components/examples/_notification.html.erb")
        )
        expect(example).to include("Ui::Notification::Component")

        # Stimulus controller
        js = File.read(File.join(root, "app/javascript/untitled_ui/notification_controller.js"))
        expect(js).to include("connect()")

        # Controller registration
        controller = File.read(
          File.join(root,
                    "app/controllers/untitled_ui/design_system/components_controller.rb")
        )
        expect(controller).to include("id: \"notification\"")
      end
    end
  end
end
