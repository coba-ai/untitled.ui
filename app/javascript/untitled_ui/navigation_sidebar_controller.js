import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["secondaryPanel"]

  showSecondary() {
    if (!this.hasSecondaryPanelTarget) return

    this.secondaryPanelTarget.classList.remove("w-0", "invisible", "border-transparent")
    this.secondaryPanelTarget.classList.add("border-secondary")
    this.secondaryPanelTarget.style.width = `${this.secondaryPanelTarget.style.getPropertyValue("--secondary-width")}px`
  }

  hideSecondary() {
    if (!this.hasSecondaryPanelTarget) return

    this.secondaryPanelTarget.classList.add("w-0", "invisible", "border-transparent")
    this.secondaryPanelTarget.classList.remove("border-secondary")
    this.secondaryPanelTarget.style.width = ""
  }
}
