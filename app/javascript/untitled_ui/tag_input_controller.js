import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textInput", "hiddenInput", "tag"]
  static values = { maxTags: Number }

  connect() {
    this.tags = this.getInitialTags()
  }

  getInitialTags() {
    const value = this.hiddenInputTarget.value
    if (!value || value.trim() === "") return []
    return value.split(",").map(t => t.trim()).filter(t => t.length > 0)
  }

  focusInput(event) {
    if (event.target === this.element || event.target.closest("[data-tag-input-target='tag']") === null) {
      this.textInputTarget.focus()
    }
  }

  onKeydown(event) {
    switch (event.key) {
      case "Enter":
      case ",":
        event.preventDefault()
        this.addTagFromInput()
        break
      case "Backspace":
        if (this.textInputTarget.value === "" && this.tags.length > 0) {
          event.preventDefault()
          this.removeLastTag()
        }
        break
      case "Tab":
        if (this.textInputTarget.value.trim() !== "") {
          event.preventDefault()
          this.addTagFromInput()
        }
        break
    }
  }

  onInput(event) {
    const value = this.textInputTarget.value
    // Support comma-separated input by triggering on comma
    if (value.endsWith(",")) {
      const tag = value.slice(0, -1).trim()
      this.textInputTarget.value = ""
      if (tag) this.addTag(tag)
    }
  }

  addTagFromInput() {
    const value = this.textInputTarget.value.trim()
    if (!value) return
    this.textInputTarget.value = ""
    this.addTag(value)
  }

  addTag(text) {
    const normalized = text.trim()
    if (!normalized) return

    // Check for duplicates
    if (this.tags.includes(normalized)) {
      this.flashDuplicate(normalized)
      return
    }

    // Check max tags
    if (this.hasMaxTagsValue && this.maxTagsValue > 0 && this.tags.length >= this.maxTagsValue) {
      return
    }

    this.tags.push(normalized)
    this.renderTag(normalized)
    this.updateHiddenInput()
  }

  renderTag(text) {
    const tag = document.createElement("span")
    tag.className = this.tagClasses()
    tag.setAttribute("data-tag-input-target", "tag")
    tag.setAttribute("data-value", text)

    const label = document.createElement("span")
    label.textContent = text

    const button = document.createElement("button")
    button.type = "button"
    button.className = this.tagRemoveClasses()
    button.setAttribute("aria-label", `Remove ${text}`)
    button.setAttribute("data-action", "click->tag-input#removeTag")

    button.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" aria-hidden="true">
      <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12"/>
    </svg>`

    tag.appendChild(label)
    tag.appendChild(button)

    // Insert before the text input
    const wrapper = this.textInputTarget.parentElement
    wrapper.insertBefore(tag, this.textInputTarget)
  }

  removeTag(event) {
    event.stopPropagation()
    const tagEl = event.currentTarget.closest("[data-tag-input-target='tag']")
    if (!tagEl) return

    const value = tagEl.dataset.value
    this.tags = this.tags.filter(t => t !== value)
    tagEl.remove()
    this.updateHiddenInput()
    this.textInputTarget.focus()
  }

  removeLastTag() {
    if (this.tags.length === 0) return

    this.tags.pop()

    const tagEls = this.tagTargets
    const lastTagEl = tagEls[tagEls.length - 1]
    if (lastTagEl) lastTagEl.remove()

    this.updateHiddenInput()
  }

  updateHiddenInput() {
    this.hiddenInputTarget.value = this.tags.join(",")
    this.hiddenInputTarget.dispatchEvent(new Event("change", { bubbles: true }))
  }

  flashDuplicate(text) {
    const tagEls = this.tagTargets
    const dupeEl = tagEls.find(el => el.dataset.value === text)
    if (!dupeEl) return

    dupeEl.classList.add("opacity-50")
    setTimeout(() => dupeEl.classList.remove("opacity-50"), 300)
  }

  tagClasses() {
    return "inline-flex items-center gap-1 rounded-md bg-utility-brand-50 px-2 py-0.5 text-sm font-medium text-utility-brand-700 ring-1 ring-inset ring-utility-brand-200"
  }

  tagRemoveClasses() {
    return "inline-flex size-3.5 shrink-0 items-center justify-center rounded-sm text-utility-brand-400 hover:bg-utility-brand-200 hover:text-utility-brand-600 focus:outline-none"
  }
}
