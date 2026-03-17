import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "panel"]

  open() {
    if (!this.hasDialogTarget || !this.hasPanelTarget) return

    // Set initial off-screen state before showing
    const isLeft = this.dialogTarget.classList.contains("justify-start")
    this.panelTarget.style.transform = isLeft ? "translateX(-100%)" : "translateX(100%)"
    this.dialogTarget.style.opacity = "0"

    this.dialogTarget.showModal()

    // Animate in after browser paints the initial state
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.panelTarget.style.transition = "transform 300ms ease-out"
        this.dialogTarget.style.transition = "opacity 200ms ease-out"
        this.panelTarget.style.transform = "translateX(0)"
        this.dialogTarget.style.opacity = "1"
      })
    })
  }

  close() {
    if (!this.hasDialogTarget || !this.hasPanelTarget) return

    const isLeft = this.dialogTarget.classList.contains("justify-start")
    this.panelTarget.style.transform = isLeft ? "translateX(-100%)" : "translateX(100%)"
    this.dialogTarget.style.opacity = "0"

    setTimeout(() => {
      this.dialogTarget.close()
      this.panelTarget.style.transform = ""
      this.panelTarget.style.transition = ""
      this.dialogTarget.style.opacity = ""
      this.dialogTarget.style.transition = ""
    }, 300)
  }

  closeOnBackdrop(event) {
    if (event.target === this.dialogTarget) {
      this.close()
    }
  }
}
