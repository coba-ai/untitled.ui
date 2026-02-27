import { Application } from "@hotwired/stimulus"

import CheckboxController from "untitled_ui/checkbox_controller"
import ClipboardController from "untitled_ui/clipboard_controller"
import DropdownController from "untitled_ui/dropdown_controller"
import ModalController from "untitled_ui/modal_controller"
import NavigationMobileController from "untitled_ui/navigation_mobile_controller"
import NavigationSidebarController from "untitled_ui/navigation_sidebar_controller"
import TabsController from "untitled_ui/tabs_controller"
import ToggleController from "untitled_ui/toggle_controller"
import TooltipController from "untitled_ui/tooltip_controller"

const controllerDefinitions = [
  ["checkbox", CheckboxController],
  ["clipboard", ClipboardController],
  ["dropdown", DropdownController],
  ["modal", ModalController],
  ["navigation-mobile", NavigationMobileController],
  ["navigation-sidebar", NavigationSidebarController],
  ["tabs", TabsController],
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
  DropdownController,
  ModalController,
  NavigationMobileController,
  NavigationSidebarController,
  TabsController,
  ToggleController,
  TooltipController
}
