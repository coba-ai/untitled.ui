import { Application } from "@hotwired/stimulus"

import CheckboxController from "untitled_ui/checkbox_controller"
import ClipboardController from "untitled_ui/clipboard_controller"
import CommandPaletteController from "untitled_ui/command_palette_controller"
import DatePickerController from "untitled_ui/date_picker_controller"
import DropdownController from "untitled_ui/dropdown_controller"
import ModalController from "untitled_ui/modal_controller"
import NavigationMobileController from "untitled_ui/navigation_mobile_controller"
import NavigationSidebarController from "untitled_ui/navigation_sidebar_controller"
import PlaygroundController from "untitled_ui/playground_controller"
import TabsController from "untitled_ui/tabs_controller"
import ToggleController from "untitled_ui/toggle_controller"
import FileUploadController from "untitled_ui/file_upload_controller"
import SelectController from "untitled_ui/select_controller"
import ToastController from "untitled_ui/toast_controller"
import TooltipController from "untitled_ui/tooltip_controller"

const controllerDefinitions = [
  ["checkbox", CheckboxController],
  ["clipboard", ClipboardController],
  ["command-palette", CommandPaletteController],
  ["date-picker", DatePickerController],
  ["dropdown", DropdownController],
  ["file-upload", FileUploadController],
  ["modal", ModalController],
  ["navigation-mobile", NavigationMobileController],
  ["navigation-sidebar", NavigationSidebarController],
  ["playground", PlaygroundController],
  ["tabs", TabsController],
  ["select", SelectController],
  ["toast", ToastController],
  ["toggle", ToggleController],
  ["tooltip", TooltipController]
]

const application = window.Stimulus || Application.start()
window.Stimulus = application

controllerDefinitions.forEach(([identifier, controller]) => {
  if (!application.router.modulesByIdentifier.has(identifier)) {
    application.register(identifier, controller)
  }
})

export {
  application,
  CheckboxController,
  ClipboardController,
  CommandPaletteController,
  DatePickerController,
  DropdownController,
  FileUploadController,
  ModalController,
  NavigationMobileController,
  NavigationSidebarController,
  PlaygroundController,
  TabsController,
  SelectController,
  ToastController,
  ToggleController,
  TooltipController
}
