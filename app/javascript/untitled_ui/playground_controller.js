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
      .then(response => {
        if (!response.ok) throw new Error(`${response.status} ${response.statusText}`)
        return response.text()
      })
      .then(html => {
        this.previewTarget.innerHTML = html
      })
      .catch(error => {
        this.previewTarget.innerHTML = `<div class="flex min-h-[120px] items-center justify-center rounded-lg border border-dashed border-error_subtle p-8"><span class="text-sm text-error-primary">Preview failed: ${error.message}</span></div>`
      })
  }
}
