import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "fill", "valueDisplay", "hiddenInput"]
  static values = { min: Number, max: Number }

  connect() {
    this.update()
  }

  update() {
    const input = this.inputTarget
    const value = parseFloat(input.value)
    const min = this.hasMinValue ? this.minValue : parseFloat(input.min) || 0
    const max = this.hasMaxValue ? this.maxValue : parseFloat(input.max) || 100
    const range = max - min
    const percentage = range === 0 ? 0 : Math.min(100, Math.max(0, ((value - min) / range) * 100))

    if (this.hasFillTarget) {
      this.fillTarget.style.width = `${percentage}%`
    }

    if (this.hasValueDisplayTarget) {
      this.valueDisplayTarget.textContent = input.value
    }

    if (this.hasHiddenInputTarget) {
      this.hiddenInputTarget.value = input.value
    }
  }
}
