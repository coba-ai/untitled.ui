import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "visual"]

  toggle() {
    this.updateVisual()
  }

  updateVisual() {
    const checked = this.inputTarget.checked
    const visual = this.visualTarget
    const checkIcon = visual.querySelector("[data-check]")
    const indeterminateIcon = visual.querySelector("[data-indeterminate]")

    if (checked) {
      visual.classList.add("bg-brand-solid", "ring-bg-brand-solid")
      visual.classList.remove("bg-primary", "ring-primary")
    } else {
      visual.classList.remove("bg-brand-solid", "ring-bg-brand-solid")
      visual.classList.add("bg-primary", "ring-primary")
    }
  }
}
