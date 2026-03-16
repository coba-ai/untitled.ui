import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toast"]
  static values = {
    autoDismiss: { type: Boolean, default: true },
    duration: { type: Number, default: 5000 }
  }

  connect() {
    // Start hidden for animation
    this.element.style.opacity = "0"
    this.element.style.transform = "translateX(1rem)"
    this.element.style.transition = "opacity 300ms ease-out, transform 300ms ease-out"

    // Animate in on next frame
    requestAnimationFrame(() => {
      this.element.style.opacity = "1"
      this.element.style.transform = "translateX(0)"
    })

    if (this.autoDismissValue) {
      this.dismissTimer = setTimeout(() => this.dismiss(), this.durationValue)
    }
  }

  disconnect() {
    if (this.dismissTimer) {
      clearTimeout(this.dismissTimer)
    }
  }

  dismiss() {
    if (this.dismissTimer) {
      clearTimeout(this.dismissTimer)
    }

    this.element.style.opacity = "0"
    this.element.style.transform = "translateX(1rem)"

    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
