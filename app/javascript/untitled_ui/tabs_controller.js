import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  select(event) {
    const selectedTab = event.currentTarget
    const index = this.tabTargets.indexOf(selectedTab)

    this.tabTargets.forEach((tab, i) => {
      const isSelected = i === index
      tab.setAttribute("aria-selected", isSelected)

      // Update active styles
      if (isSelected) {
        tab.classList.remove("text-quaternary")
      } else {
        tab.classList.add("text-quaternary")
      }
    })

    this.panelTargets.forEach((panel, i) => {
      if (i === index) {
        panel.classList.remove("hidden")
      } else {
        panel.classList.add("hidden")
      }
    })
  }
}
