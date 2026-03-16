import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trigger", "dropdown", "search", "option", "optionsList", "noResults", "hiddenInput", "display"]
  static values = { searchable: Boolean, options: Array }

  connect() {
    this.isOpen = false
    this.highlightedIndex = -1
    this.closeOnClickOutside = this.closeOnClickOutside.bind(this)
    this.closeOnEscape = this.closeOnEscape.bind(this)
  }

  toggle(event) {
    event.stopPropagation()
    if (this.triggerTarget.getAttribute("aria-disabled") === "true") return

    if (this.isOpen) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.isOpen = true
    this.dropdownTarget.classList.remove("hidden")
    this.triggerTarget.setAttribute("aria-expanded", "true")
    this.highlightedIndex = -1

    document.addEventListener("click", this.closeOnClickOutside)
    document.addEventListener("keydown", this.closeOnEscape)

    if (this.searchableValue && this.hasSearchTarget) {
      this.searchTarget.value = ""
      this.filter()
      requestAnimationFrame(() => this.searchTarget.focus())
    }

    // Highlight the currently selected option
    const currentValue = this.hiddenInputTarget.value
    if (currentValue) {
      const index = this.visibleOptions().findIndex(
        opt => opt.dataset.value === currentValue
      )
      if (index >= 0) {
        this.highlightedIndex = index
        this.updateHighlight()
      }
    }
  }

  close() {
    this.isOpen = false
    this.dropdownTarget.classList.add("hidden")
    this.triggerTarget.setAttribute("aria-expanded", "false")
    this.highlightedIndex = -1
    this.clearHighlight()

    document.removeEventListener("click", this.closeOnClickOutside)
    document.removeEventListener("keydown", this.closeOnEscape)
  }

  selectOption(event) {
    const option = event.currentTarget
    const value = option.dataset.value
    const label = option.dataset.label

    this.hiddenInputTarget.value = value
    this.displayTarget.innerHTML = this.escapeHtml(label)

    // Update aria-selected and check marks
    this.optionTargets.forEach(opt => {
      opt.setAttribute("aria-selected", opt.dataset.value === value)
      const checkContainer = opt.querySelector(".flex")
      const existingCheck = checkContainer?.querySelector("svg")
      if (existingCheck) existingCheck.remove()

      if (opt.dataset.value === value) {
        const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg")
        svg.setAttribute("class", "size-4 text-brand-solid")
        svg.setAttribute("fill", "none")
        svg.setAttribute("viewBox", "0 0 24 24")
        svg.setAttribute("stroke-width", "2.5")
        svg.setAttribute("stroke", "currentColor")
        svg.setAttribute("aria-hidden", "true")
        const path = document.createElementNS("http://www.w3.org/2000/svg", "path")
        path.setAttribute("stroke-linecap", "round")
        path.setAttribute("stroke-linejoin", "round")
        path.setAttribute("d", "m4.5 12.75 6 6 9-13.5")
        svg.appendChild(path)
        checkContainer.appendChild(svg)
      }
    })

    // Dispatch change event on hidden input for form frameworks
    this.hiddenInputTarget.dispatchEvent(new Event("change", { bubbles: true }))

    this.close()
    this.triggerTarget.focus()
  }

  highlightOption(event) {
    const index = parseInt(event.currentTarget.dataset.index, 10)
    const visible = this.visibleOptions()
    const visibleIndex = visible.indexOf(event.currentTarget)
    if (visibleIndex >= 0) {
      this.highlightedIndex = visibleIndex
      this.updateHighlight()
    }
  }

  filter() {
    if (!this.hasSearchTarget) return

    const query = this.searchTarget.value.toLowerCase()
    let visibleCount = 0

    this.optionTargets.forEach(option => {
      const label = option.dataset.label.toLowerCase()
      if (label.includes(query)) {
        option.classList.remove("hidden")
        visibleCount++
      } else {
        option.classList.add("hidden")
      }
    })

    if (this.hasNoResultsTarget) {
      if (visibleCount === 0) {
        this.noResultsTarget.classList.remove("hidden")
      } else {
        this.noResultsTarget.classList.add("hidden")
      }
    }

    this.highlightedIndex = -1
    this.clearHighlight()
  }

  onTriggerKeydown(event) {
    if (this.triggerTarget.getAttribute("aria-disabled") === "true") return

    switch (event.key) {
      case "Enter":
      case " ":
      case "ArrowDown":
        event.preventDefault()
        if (!this.isOpen) {
          this.open()
        }
        break
      case "ArrowUp":
        event.preventDefault()
        if (!this.isOpen) {
          this.open()
        }
        break
    }
  }

  onSearchKeydown(event) {
    this.handleDropdownKeydown(event)
  }

  handleDropdownKeydown(event) {
    const visible = this.visibleOptions()
    if (visible.length === 0) return

    switch (event.key) {
      case "ArrowDown":
        event.preventDefault()
        this.highlightedIndex = (this.highlightedIndex + 1) % visible.length
        this.updateHighlight()
        break
      case "ArrowUp":
        event.preventDefault()
        this.highlightedIndex = this.highlightedIndex <= 0 ? visible.length - 1 : this.highlightedIndex - 1
        this.updateHighlight()
        break
      case "Enter":
        event.preventDefault()
        if (this.highlightedIndex >= 0 && this.highlightedIndex < visible.length) {
          visible[this.highlightedIndex].click()
        }
        break
      case "Escape":
        event.preventDefault()
        this.close()
        this.triggerTarget.focus()
        break
      case "Tab":
        this.close()
        break
    }
  }

  closeOnClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }

  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.close()
      this.triggerTarget.focus()
    }
  }

  visibleOptions() {
    return this.optionTargets.filter(opt => !opt.classList.contains("hidden"))
  }

  updateHighlight() {
    const visible = this.visibleOptions()
    visible.forEach((opt, i) => {
      if (i === this.highlightedIndex) {
        opt.classList.add("bg-primary_hover")
        opt.scrollIntoView({ block: "nearest" })
      } else {
        opt.classList.remove("bg-primary_hover")
      }
    })
  }

  clearHighlight() {
    this.optionTargets.forEach(opt => {
      opt.classList.remove("bg-primary_hover")
    })
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }

  disconnect() {
    document.removeEventListener("click", this.closeOnClickOutside)
    document.removeEventListener("keydown", this.closeOnEscape)
  }
}
