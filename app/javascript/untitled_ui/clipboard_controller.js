import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "button", "feedback"]
  static values = {
    successDuration: { type: Number, default: 2000 }
  }

  connect() {
    this.originalButtonHTML = this.buttonTarget.innerHTML
  }

  copy(event) {
    event.preventDefault()
    const text = this.sourceTarget.textContent.trim()

    navigator.clipboard.writeText(text).then(() => {
      this.showSuccess()
    }).catch(err => {
      console.error('Failed to copy:', err)
      this.showError()
    })
  }

  showSuccess() {
    // Update button
    this.buttonTarget.innerHTML = `
      <svg class="size-4" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
      </svg>
    `
    this.buttonTarget.classList.add('text-green-600', 'dark:text-green-400')

    // Show feedback message if target exists
    if (this.hasFeedbackTarget) {
      this.feedbackTarget.textContent = 'Copied!'
      this.feedbackTarget.classList.remove('opacity-0')
      this.feedbackTarget.classList.add('opacity-100')
    }

    setTimeout(() => {
      this.reset()
    }, this.successDurationValue)
  }

  showError() {
    if (this.hasFeedbackTarget) {
      this.feedbackTarget.textContent = 'Failed to copy'
      this.feedbackTarget.classList.remove('opacity-0')
      this.feedbackTarget.classList.add('opacity-100', 'text-red-600', 'dark:text-red-400')

      setTimeout(() => {
        this.reset()
      }, this.successDurationValue)
    }
  }

  reset() {
    this.buttonTarget.innerHTML = this.originalButtonHTML
    this.buttonTarget.classList.remove('text-green-600', 'dark:text-green-400')

    if (this.hasFeedbackTarget) {
      this.feedbackTarget.classList.remove('opacity-100')
      this.feedbackTarget.classList.add('opacity-0')
      this.feedbackTarget.classList.remove('text-red-600', 'dark:text-red-400')
    }
  }
}
