import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trigger", "panel", "swatch", "display", "hidden", "hexInput", "hexSwatch", "swatchButton"]
  static values = {
    value: { type: String, default: "#000000" }
  }

  connect() {
    this.closeOnClickOutside = this.closeOnClickOutside.bind(this)
    this.closeOnEscape = this.closeOnEscape.bind(this)
    this.syncUI(this.valueValue)
  }

  disconnect() {
    document.removeEventListener("click", this.closeOnClickOutside)
    document.removeEventListener("keydown", this.closeOnEscape)
  }

  toggle(event) {
    event.stopPropagation()
    if (this.panelTarget.classList.contains("hidden")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.panelTarget.classList.remove("hidden")
    if (this.hasTriggerTarget) {
      this.triggerTarget.setAttribute("aria-expanded", "true")
    }
    if (this.hasDisplayTarget) {
      this.displayTarget.setAttribute("aria-expanded", "true")
    }
    // Sync hex input with current value (strip leading #)
    if (this.hasHexInputTarget) {
      this.hexInputTarget.value = this.valueValue.replace(/^#/, "")
    }
    this.highlightActiveSwatch()
    document.addEventListener("click", this.closeOnClickOutside)
    document.addEventListener("keydown", this.closeOnEscape)
  }

  close() {
    this.panelTarget.classList.add("hidden")
    if (this.hasTriggerTarget) {
      this.triggerTarget.setAttribute("aria-expanded", "false")
    }
    if (this.hasDisplayTarget) {
      this.displayTarget.setAttribute("aria-expanded", "false")
    }
    document.removeEventListener("click", this.closeOnClickOutside)
    document.removeEventListener("keydown", this.closeOnEscape)
  }

  closeOnClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }

  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  selectSwatch(event) {
    event.stopPropagation()
    const btn = event.currentTarget
    const color = btn.dataset.color
    if (!color) return
    this.selectColor(color)
    this.close()
  }

  onHexInput(event) {
    const raw = event.target.value.replace(/[^0-9a-fA-F]/g, "")
    event.target.value = raw

    if (raw.length === 3 || raw.length === 6) {
      const color = "#" + (raw.length === 3 ? raw.split("").map(c => c + c).join("") : raw)
      this.selectColor(color, { updateHexInput: false })
    }
  }

  onHexKeydown(event) {
    if (event.key === "Enter") {
      const raw = event.target.value.replace(/[^0-9a-fA-F]/g, "")
      if (raw.length === 6) {
        this.selectColor("#" + raw)
        this.close()
      } else if (raw.length === 3) {
        const expanded = raw.split("").map(c => c + c).join("")
        this.selectColor("#" + expanded)
        this.close()
      }
    }
  }

  selectColor(color, { updateHexInput = true } = {}) {
    const normalized = this.normalizeHex(color)
    if (!normalized) return

    this.valueValue = normalized
    this.syncUI(normalized, { updateHexInput })

    // Dispatch change event for form integration
    if (this.hasHiddenTarget) {
      this.hiddenTarget.dispatchEvent(new Event("change", { bubbles: true }))
    }
  }

  syncUI(color, { updateHexInput = true } = {}) {
    // Update swatch preview in trigger
    if (this.hasSwatchTarget) {
      this.swatchTarget.style.backgroundColor = color
    }
    // Update display input
    if (this.hasDisplayTarget) {
      this.displayTarget.value = color
    }
    // Update hidden input
    if (this.hasHiddenTarget) {
      this.hiddenTarget.value = color
    }
    // Update hex swatch in panel
    if (this.hasHexSwatchTarget) {
      this.hexSwatchTarget.style.backgroundColor = color
    }
    // Update hex input in panel
    if (updateHexInput && this.hasHexInputTarget) {
      this.hexInputTarget.value = color.replace(/^#/, "")
    }
    this.highlightActiveSwatch()
  }

  highlightActiveSwatch() {
    if (!this.hasSwatchButtonTarget) return
    const current = (this.valueValue || "").toUpperCase()
    this.swatchButtonTargets.forEach(btn => {
      const btnColor = (btn.dataset.color || "").toUpperCase()
      if (btnColor === current) {
        btn.classList.add("border-brand", "scale-110")
        btn.classList.remove("border-transparent")
      } else {
        btn.classList.remove("border-brand", "scale-110")
        btn.classList.add("border-transparent")
      }
    })
  }

  normalizeHex(color) {
    if (!color) return null
    let hex = color.trim()
    if (!hex.startsWith("#")) hex = "#" + hex
    // Expand 3-char shorthand
    if (/^#[0-9a-fA-F]{3}$/.test(hex)) {
      hex = "#" + hex.slice(1).split("").map(c => c + c).join("")
    }
    if (/^#[0-9a-fA-F]{6}$/.test(hex)) {
      return hex.toUpperCase()
    }
    return null
  }
}
