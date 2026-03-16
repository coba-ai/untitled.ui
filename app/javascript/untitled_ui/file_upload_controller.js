import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["zone", "input", "text", "filename"]

  openDialog(event) {
    if (this.inputTarget.disabled) return
    // Prevent double-trigger when clicking the input itself
    if (event.target === this.inputTarget) return
    this.inputTarget.click()
  }

  dragEnter(event) {
    event.preventDefault()
    if (this.inputTarget.disabled) return
    this.zoneTarget.classList.add("border-brand-solid", "bg-primary_hover")
  }

  dragOver(event) {
    event.preventDefault()
  }

  dragLeave(event) {
    event.preventDefault()
    this.zoneTarget.classList.remove("border-brand-solid", "bg-primary_hover")
  }

  drop(event) {
    event.preventDefault()
    if (this.inputTarget.disabled) return
    this.zoneTarget.classList.remove("border-brand-solid", "bg-primary_hover")

    const files = event.dataTransfer.files
    if (files.length > 0) {
      this.inputTarget.files = files
      this.displayFileNames(files)
    }
  }

  fileSelected() {
    const files = this.inputTarget.files
    if (files.length > 0) {
      this.displayFileNames(files)
    }
  }

  displayFileNames(files) {
    const names = Array.from(files).map(f => f.name).join(", ")
    this.filenameTarget.textContent = names
    this.filenameTarget.classList.remove("hidden")
    this.textTarget.classList.add("hidden")
  }
}
