import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "header", "panel", "chevron"]
  static values = { multiple: Boolean }

  connect() {
    // Initialize heights for items that start open
    this.headerTargets.forEach((header, index) => {
      const panel = this.panelTargets[index]
      if (!panel) return

      if (header.getAttribute("aria-expanded") === "true") {
        panel.style.height = panel.scrollHeight + "px"
      } else {
        panel.style.height = "0"
      }
    })
  }

  toggle(event) {
    const header = event.currentTarget
    const index = this.headerTargets.indexOf(header)
    const panel = this.panelTargets[index]
    const chevron = this.chevronTargets[index]

    if (!panel) return

    const isExpanded = header.getAttribute("aria-expanded") === "true"

    if (!isExpanded) {
      // Collapse others if multiple is not allowed
      if (!this.multipleValue) {
        this.headerTargets.forEach((otherHeader, i) => {
          if (i !== index && otherHeader.getAttribute("aria-expanded") === "true") {
            this._collapse(otherHeader, this.panelTargets[i], this.chevronTargets[i])
          }
        })
      }
      this._expand(header, panel, chevron)
    } else {
      this._collapse(header, panel, chevron)
    }
  }

  _expand(header, panel, chevron) {
    header.setAttribute("aria-expanded", "true")
    panel.style.height = panel.scrollHeight + "px"
    if (chevron) chevron.classList.add("rotate-180")
  }

  _collapse(header, panel, chevron) {
    header.setAttribute("aria-expanded", "false")
    panel.style.height = "0"
    if (chevron) chevron.classList.remove("rotate-180")
  }
}
