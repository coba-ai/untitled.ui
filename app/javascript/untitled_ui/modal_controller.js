import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  open(event) {
    event.preventDefault()
    const modal = document.getElementById("invite-modal")
    if (modal) {
      modal.classList.remove("hidden")
    }
  }

  close(event) {
    event.preventDefault()
    const modal = document.getElementById("invite-modal")
    if (modal) {
      modal.classList.add("hidden")
    }
  }

  closeOnBackdrop(event) {
    if (event.target === event.currentTarget) {
      this.close(event)
    }
  }
}
