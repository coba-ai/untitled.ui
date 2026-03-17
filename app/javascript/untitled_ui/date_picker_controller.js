import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trigger", "calendar", "days", "monthYear", "display", "hidden"]
  static values = {
    value: { type: String, default: "" },
    format: { type: String, default: "%Y-%m-%d" },
    min: { type: String, default: "" },
    max: { type: String, default: "" }
  }

  connect() {
    this.closeOnClickOutside = this.closeOnClickOutside.bind(this)
    this.closeOnEscape = this.closeOnEscape.bind(this)

    const today = new Date()
    if (this.valueValue) {
      const parsed = this.parseDate(this.valueValue)
      this.viewYear = parsed.getFullYear()
      this.viewMonth = parsed.getMonth()
    } else {
      this.viewYear = today.getFullYear()
      this.viewMonth = today.getMonth()
    }

    this.render()
  }

  toggle(event) {
    event.stopPropagation()
    if (this.calendarTarget.classList.contains("hidden")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.calendarTarget.classList.remove("hidden")
    document.addEventListener("click", this.closeOnClickOutside)
    document.addEventListener("keydown", this.closeOnEscape)
  }

  close() {
    this.calendarTarget.classList.add("hidden")
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

  prevMonth(event) {
    event.stopPropagation()
    this.viewMonth--
    if (this.viewMonth < 0) {
      this.viewMonth = 11
      this.viewYear--
    }
    this.render()
  }

  nextMonth(event) {
    event.stopPropagation()
    this.viewMonth++
    if (this.viewMonth > 11) {
      this.viewMonth = 0
      this.viewYear++
    }
    this.render()
  }

  selectDay(event) {
    event.stopPropagation()
    const btn = event.currentTarget
    const dateStr = btn.dataset.date
    if (!dateStr || btn.disabled) return

    this.valueValue = dateStr
    this.hiddenTarget.value = dateStr
    this.displayTarget.value = this.formatDate(this.parseDate(dateStr))

    // Dispatch change event on hidden input for form libraries
    this.hiddenTarget.dispatchEvent(new Event("change", { bubbles: true }))

    this.render()
    this.close()
  }

  render() {
    const monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ]

    this.monthYearTarget.textContent = `${monthNames[this.viewMonth]} ${this.viewYear}`

    const firstDay = new Date(this.viewYear, this.viewMonth, 1).getDay()
    const daysInMonth = new Date(this.viewYear, this.viewMonth + 1, 0).getDate()

    const today = new Date()
    today.setHours(0, 0, 0, 0)

    const selectedDate = this.valueValue ? this.parseDate(this.valueValue) : null
    const minDate = this.minValue ? this.parseDate(this.minValue) : null
    const maxDate = this.maxValue ? this.parseDate(this.maxValue) : null

    let html = ""

    // Empty cells for days before the first of the month
    for (let i = 0; i < firstDay; i++) {
      html += '<span class="h-8 w-8"></span>'
    }

    for (let day = 1; day <= daysInMonth; day++) {
      const date = new Date(this.viewYear, this.viewMonth, day)
      date.setHours(0, 0, 0, 0)
      const dateStr = this.toISODate(date)

      const isToday = date.getTime() === today.getTime()
      const isSelected = selectedDate && date.getTime() === selectedDate.getTime()
      const isDisabled = (minDate && date < minDate) || (maxDate && date > maxDate)

      let classes = "flex h-8 w-8 items-center justify-center rounded-full text-sm transition-colors"

      if (isSelected) {
        classes += " bg-brand-solid text-white font-semibold"
      } else if (isDisabled) {
        classes += " text-disabled cursor-not-allowed"
      } else if (isToday) {
        classes += " font-semibold text-brand-secondary ring-1 ring-brand ring-inset"
      } else {
        classes += " text-secondary hover:bg-secondary cursor-pointer"
      }

      if (isDisabled) {
        html += `<button type="button" class="${classes}" disabled data-date="${dateStr}">${day}</button>`
      } else {
        html += `<button type="button" class="${classes}" data-date="${dateStr}" data-action="click->date-picker#selectDay">${day}</button>`
      }
    }

    this.daysTarget.innerHTML = html
  }

  parseDate(str) {
    const parts = str.split("-")
    const date = new Date(parseInt(parts[0]), parseInt(parts[1]) - 1, parseInt(parts[2]))
    date.setHours(0, 0, 0, 0)
    return date
  }

  toISODate(date) {
    const y = date.getFullYear()
    const m = String(date.getMonth() + 1).padStart(2, "0")
    const d = String(date.getDate()).padStart(2, "0")
    return `${y}-${m}-${d}`
  }

  formatDate(date) {
    const fmt = this.formatValue
    const y = date.getFullYear()
    const m = String(date.getMonth() + 1).padStart(2, "0")
    const d = String(date.getDate()).padStart(2, "0")

    return fmt
      .replace("%Y", y)
      .replace("%m", m)
      .replace("%d", d)
      .replace("%b", date.toLocaleString("en-US", { month: "short" }))
      .replace("%B", date.toLocaleString("en-US", { month: "long" }))
  }

  disconnect() {
    document.removeEventListener("click", this.closeOnClickOutside)
    document.removeEventListener("keydown", this.closeOnEscape)
  }
}
