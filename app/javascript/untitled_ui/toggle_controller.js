import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "track", "thumb"]

  toggle() {
    const checked = this.inputTarget.checked

    if (checked) {
      this.trackTarget.classList.add("bg-brand-solid")
      this.trackTarget.classList.remove("bg-tertiary")
      this.thumbTarget.classList.add(this.translateClass)
    } else {
      this.trackTarget.classList.remove("bg-brand-solid")
      this.trackTarget.classList.add("bg-tertiary")
      this.thumbTarget.classList.remove(this.translateClass)
    }
  }

  get translateClass() {
    // Detect from thumb size
    return this.thumbTarget.classList.contains("size-5") ? "translate-x-5" : "translate-x-4"
  }
}
