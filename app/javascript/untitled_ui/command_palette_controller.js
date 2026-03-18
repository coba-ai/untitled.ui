import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "input", "list", "item", "groupHeader", "emptyState", "group"]
  static values = {
    items: Array,
    paletteId: String
  }

  connect() {
    this.activeIndex = -1
    this.visibleItems = []
    this.openOnCmdK = this.openOnCmdK.bind(this)
    document.addEventListener("keydown", this.openOnCmdK)
  }

  disconnect() {
    document.removeEventListener("keydown", this.openOnCmdK)
  }

  // Open the command palette on Cmd+K (Mac) or Ctrl+K (Windows/Linux)
  openOnCmdK(event) {
    if ((event.metaKey || event.ctrlKey) && event.key === "k") {
      event.preventDefault()
      this.open()
    }
  }

  open() {
    if (this.hasDialogTarget) {
      this.dialogTarget.showModal()
      this.reset()
      // Focus the input after a brief tick to ensure the dialog is visible
      requestAnimationFrame(() => {
        if (this.hasInputTarget) {
          this.inputTarget.focus()
        }
      })
    }
  }

  close() {
    if (this.hasDialogTarget) {
      this.dialogTarget.close()
    }
  }

  closeOnBackdrop(event) {
    if (event.target === this.dialogTarget) {
      this.close()
    }
  }

  reset() {
    if (this.hasInputTarget) {
      this.inputTarget.value = ""
    }
    this.activeIndex = -1
    this.showAllItems()
  }

  showAllItems() {
    this.itemTargets.forEach(item => {
      item.closest("[data-command-palette-group]")?.classList.remove("hidden")
      item.classList.remove("hidden")
      item.removeAttribute("data-active")
      item.setAttribute("aria-selected", "false")
    })

    if (this.hasGroupHeaderTarget) {
      this.groupHeaderTargets.forEach(header => header.classList.remove("hidden"))
    }

    if (this.hasEmptyStateTarget) {
      this.emptyStateTarget.classList.add("hidden")
    }

    this.visibleItems = [...this.itemTargets]
  }

  filter() {
    const query = this.hasInputTarget ? this.inputTarget.value.trim().toLowerCase() : ""
    this.activeIndex = -1

    // Clear active state
    this.itemTargets.forEach(item => {
      item.removeAttribute("data-active")
      item.setAttribute("aria-selected", "false")
    })

    if (!query) {
      this.showAllItems()
      return
    }

    this.visibleItems = []
    const groupVisibility = new Map()

    this.itemTargets.forEach(item => {
      const label = (item.dataset.label || "").toLowerCase()
      const group = item.dataset.group || ""
      const matches = label.includes(query)

      if (matches) {
        item.classList.remove("hidden")
        this.visibleItems.push(item)
        groupVisibility.set(group, true)
      } else {
        item.classList.add("hidden")
      }
    })

    // Show/hide group headers based on whether the group has visible items
    if (this.hasGroupTarget) {
      this.groupTargets.forEach(groupEl => {
        const groupName = groupEl.dataset.groupName || ""
        if (groupVisibility.has(groupName)) {
          groupEl.classList.remove("hidden")
        } else {
          groupEl.classList.add("hidden")
        }
      })
    }

    if (this.hasEmptyStateTarget) {
      if (this.visibleItems.length === 0) {
        this.emptyStateTarget.classList.remove("hidden")
      } else {
        this.emptyStateTarget.classList.add("hidden")
      }
    }
  }

  handleKeydown(event) {
    switch (event.key) {
      case "ArrowDown":
        event.preventDefault()
        this.moveActive(1)
        break
      case "ArrowUp":
        event.preventDefault()
        this.moveActive(-1)
        break
      case "Enter":
        event.preventDefault()
        this.selectActive()
        break
      case "Escape":
        event.preventDefault()
        this.close()
        break
    }
  }

  moveActive(direction) {
    if (this.visibleItems.length === 0) return

    const newIndex = this.activeIndex + direction

    if (newIndex < 0) {
      this.setActiveIndex(this.visibleItems.length - 1)
    } else if (newIndex >= this.visibleItems.length) {
      this.setActiveIndex(0)
    } else {
      this.setActiveIndex(newIndex)
    }
  }

  setActiveIndex(index) {
    // Deactivate current
    if (this.activeIndex >= 0 && this.visibleItems[this.activeIndex]) {
      this.visibleItems[this.activeIndex].removeAttribute("data-active")
      this.visibleItems[this.activeIndex].setAttribute("aria-selected", "false")
    }

    this.activeIndex = index

    // Activate new
    if (this.activeIndex >= 0 && this.visibleItems[this.activeIndex]) {
      const activeItem = this.visibleItems[this.activeIndex]
      activeItem.setAttribute("data-active", "")
      activeItem.setAttribute("aria-selected", "true")
      activeItem.scrollIntoView({ block: "nearest" })
    }
  }

  setActive(event) {
    const item = event.currentTarget
    const index = this.visibleItems.indexOf(item)
    if (index !== -1) {
      this.setActiveIndex(index)
    }
  }

  selectActive() {
    if (this.activeIndex >= 0 && this.visibleItems[this.activeIndex]) {
      this.selectItem({ currentTarget: this.visibleItems[this.activeIndex] })
    }
  }

  selectItem(event) {
    const item = event.currentTarget
    const value = item.dataset.value
    const label = item.dataset.label
    const group = item.dataset.group

    // Dispatch custom event with selected item data
    this.element.dispatchEvent(new CustomEvent("command-palette:select", {
      bubbles: true,
      detail: { value, label, group }
    }))

    this.close()
  }
}
