import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["selectAll", "rowCheckbox", "bulkActions", "sortButton"]

  connect() {
    this.updateBulkActions()
    this.updateSelectAll()
  }

  // Row selection

  toggleSelectAll(event) {
    const checked = event.currentTarget.checked
    this.rowCheckboxTargets.forEach(checkbox => {
      checkbox.checked = checked
      this.updateRowHighlight(checkbox)
    })
    this.updateBulkActions()
  }

  toggleRow(event) {
    this.updateRowHighlight(event.currentTarget)
    this.updateSelectAll()
    this.updateBulkActions()
  }

  updateRowHighlight(checkbox) {
    const row = checkbox.closest("tr")
    if (!row) return
    if (checkbox.checked) {
      row.classList.add("bg-brand-primary")
    } else {
      row.classList.remove("bg-brand-primary")
    }
  }

  updateSelectAll() {
    if (!this.hasSelectAllTarget) return
    const total = this.rowCheckboxTargets.length
    const checked = this.rowCheckboxTargets.filter(cb => cb.checked).length
    const selectAll = this.selectAllTarget
    if (total === 0) {
      selectAll.checked = false
      selectAll.indeterminate = false
    } else if (checked === total) {
      selectAll.checked = true
      selectAll.indeterminate = false
    } else if (checked === 0) {
      selectAll.checked = false
      selectAll.indeterminate = false
    } else {
      selectAll.checked = false
      selectAll.indeterminate = true
    }
  }

  updateBulkActions() {
    if (!this.hasBulkActionsTarget) return
    const anyChecked = this.rowCheckboxTargets.some(cb => cb.checked)
    if (anyChecked) {
      this.bulkActionsTarget.classList.remove("hidden")
    } else {
      this.bulkActionsTarget.classList.add("hidden")
    }
  }

  get selectedCount() {
    return this.rowCheckboxTargets.filter(cb => cb.checked).length
  }

  // Sorting

  sort(event) {
    const button = event.currentTarget
    const column = button.dataset.column
    const currentDir = button.getAttribute("aria-sort") || "none"
    const nextDir = currentDir === "ascending" ? "descending" : "ascending"

    // Reset all sort buttons
    this.sortButtonTargets.forEach(btn => {
      btn.setAttribute("aria-sort", "none")
      this.updateSortIcon(btn, "none")
    })

    // Set new sort direction
    button.setAttribute("aria-sort", nextDir)
    this.updateSortIcon(button, nextDir)

    // Sort the table rows
    this.sortRows(column, nextDir)
  }

  updateSortIcon(button, direction) {
    const ascIcon = button.querySelector("[data-sort-asc]")
    const descIcon = button.querySelector("[data-sort-desc]")
    const defaultIcon = button.querySelector("[data-sort-default]")

    if (ascIcon) ascIcon.classList.toggle("hidden", direction !== "ascending")
    if (descIcon) descIcon.classList.toggle("hidden", direction !== "descending")
    if (defaultIcon) defaultIcon.classList.toggle("hidden", direction !== "none")
  }

  sortRows(column, direction) {
    const tbody = this.element.querySelector("tbody")
    if (!tbody) return

    const rows = Array.from(tbody.querySelectorAll("tr"))
    const columnIndex = parseInt(column, 10)

    rows.sort((a, b) => {
      const aCell = a.querySelectorAll("td")[columnIndex]
      const bCell = b.querySelectorAll("td")[columnIndex]
      if (!aCell || !bCell) return 0

      const aText = aCell.textContent.trim().toLowerCase()
      const bText = bCell.textContent.trim().toLowerCase()

      // Try numeric sort
      const aNum = parseFloat(aText)
      const bNum = parseFloat(bText)
      if (!isNaN(aNum) && !isNaN(bNum)) {
        return direction === "ascending" ? aNum - bNum : bNum - aNum
      }

      // Fallback to string sort
      if (aText < bText) return direction === "ascending" ? -1 : 1
      if (aText > bText) return direction === "ascending" ? 1 : -1
      return 0
    })

    rows.forEach(row => tbody.appendChild(row))
  }
}
