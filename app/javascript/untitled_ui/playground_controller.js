import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "preview"]
  static values = { url: String }

  connect() {
    this.submitForm()
  }

  change() {
    clearTimeout(this._debounce)
    this._debounce = setTimeout(() => this.submitForm(), 120)
  }

  submitForm() {
    const form = this.formTarget
    const params = new URLSearchParams(new FormData(form))
    const url = `${this.urlValue}?${params.toString()}`

    fetch(url, {
      headers: { "X-Requested-With": "XMLHttpRequest" }
    })
      .then(response => response.text())
      .then(html => {
        this.previewTarget.innerHTML = html
      })
  }
}
