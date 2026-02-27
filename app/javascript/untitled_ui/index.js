import { Application } from "@hotwired/stimulus"

import CheckboxController from "./checkbox_controller"
import ClipboardController from "./clipboard_controller"
import DropdownController from "./dropdown_controller"
import ModalController from "./modal_controller"
import NavigationMobileController from "./navigation_mobile_controller"
import NavigationSidebarController from "./navigation_sidebar_controller"
import TabsController from "./tabs_controller"
import ToggleController from "./toggle_controller"
import TooltipController from "./tooltip_controller"

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
