import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trigger", "content"]
  static values = { placement: { type: String, default: "top" } }

  show() {
    this.contentTarget.classList.remove("hidden", "opacity-0")
    this.contentTarget.classList.add("opacity-100")
    this.position()
  }

  hide() {
    this.contentTarget.classList.remove("opacity-100")
    this.contentTarget.classList.add("opacity-0")
    setTimeout(() => this.contentTarget.classList.add("hidden"), 150)
  }

  position() {
    const trigger = this.triggerTarget
    const content = this.contentTarget
    const placement = this.placementValue

    // Reset position
    content.style.left = ""
    content.style.top = ""
    content.style.bottom = ""
    content.style.right = ""

    const triggerRect = trigger.getBoundingClientRect()
    const contentRect = content.getBoundingClientRect()

    switch (placement) {
      case "top":
        content.style.bottom = "100%"
        content.style.left = "50%"
        content.style.transform = "translateX(-50%)"
        content.style.marginBottom = "6px"
        break
      case "bottom":
        content.style.top = "100%"
        content.style.left = "50%"
        content.style.transform = "translateX(-50%)"
        content.style.marginTop = "6px"
        break
      case "left":
        content.style.right = "100%"
        content.style.top = "50%"
        content.style.transform = "translateY(-50%)"
        content.style.marginRight = "6px"
        break
      case "right":
        content.style.left = "100%"
        content.style.top = "50%"
        content.style.transform = "translateY(-50%)"
        content.style.marginLeft = "6px"
        break
    }
  }
}
