import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "visual"]

  connect() {
    this.updateVisual()
  }

  toggle() {
    this.updateVisual()
  }

  updateVisual() {
    const checked = this.inputTarget.checked
    const visual = this.visualTarget
    const svgs = visual.querySelectorAll("svg")
    const indeterminateIcon = svgs[0]
    const checkIcon = svgs[1]

    if (checked) {
      visual.classList.add("bg-brand-solid", "ring-bg-brand-solid")
      visual.classList.remove("bg-primary", "ring-primary")
      if (checkIcon) checkIcon.style.opacity = "1"
      if (indeterminateIcon) indeterminateIcon.style.opacity = "0"
    } else {
      visual.classList.remove("bg-brand-solid", "ring-bg-brand-solid")
      visual.classList.add("bg-primary", "ring-primary")
      if (checkIcon) checkIcon.style.opacity = "0"
      if (indeterminateIcon) indeterminateIcon.style.opacity = "0"
    }
  }
}
