import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "stepButton", "prevButton", "nextButton", "finishButton", "stepCounter"]
  static values = { currentStep: Number, totalSteps: Number }

  connect() {
    this.update()
  }

  next() {
    if (this.currentStepValue < this.totalStepsValue) {
      this.currentStepValue++
      this.update()
    }
  }

  prev() {
    if (this.currentStepValue > 1) {
      this.currentStepValue--
      this.update()
    }
  }

  goToStep(event) {
    const step = parseInt(event.currentTarget.dataset.stepIndex, 10)
    if (step >= 1 && step <= this.totalStepsValue) {
      this.currentStepValue = step
      this.update()
    }
  }

  update() {
    const current = this.currentStepValue
    const total = this.totalStepsValue

    // Update panels visibility
    this.panelTargets.forEach((panel, i) => {
      if (i + 1 === current) {
        panel.classList.remove("hidden")
      } else {
        panel.classList.add("hidden")
      }
    })

    // Update step buttons appearance
    this.stepButtonTargets.forEach((btn, i) => {
      const stepIndex = i + 1
      const dot = btn.querySelector("span")

      // Remove all state classes first
      btn.classList.remove(
        "border-transparent", "bg-brand-solid",
        "border-brand-solid", "bg-primary",
        "border-secondary"
      )

      if (stepIndex < current) {
        // Completed
        btn.classList.add("border-transparent", "bg-brand-solid")
        btn.setAttribute("aria-current", null)
        btn.removeAttribute("aria-current")
        if (dot) {
          dot.innerHTML = '<svg fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="size-4 shrink-0 text-white"><path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5" /></svg>'
          dot.className = "size-4 shrink-0 text-white"
        }
      } else if (stepIndex === current) {
        // Current
        btn.classList.add("border-brand-solid", "bg-primary")
        btn.setAttribute("aria-current", "step")
        if (dot) {
          dot.innerHTML = ""
          dot.className = "block h-2.5 w-2.5 rounded-full bg-brand-solid"
        }
      } else {
        // Upcoming
        btn.classList.add("border-secondary", "bg-primary")
        btn.removeAttribute("aria-current")
        if (dot) {
          dot.innerHTML = ""
          dot.className = "block h-2.5 w-2.5 rounded-full bg-quaternary"
        }
      }
    })

    // Update connector lines
    const connectors = this.element.querySelectorAll("nav .h-0\\.5.w-full:not(.invisible)")
    // Connectors are between step buttons; update left/right connectors per step
    const allStepContainers = this.element.querySelectorAll("nav > div")
    allStepContainers.forEach((container, i) => {
      const stepIndex = i + 1
      const divs = container.querySelectorAll(":scope > div.flex > div.h-0\\.5")

      divs.forEach((connector, ci) => {
        if (ci === 0) {
          // Left connector: completed if previous step is completed
          const prevCompleted = (i > 0) && ((i) < current)
          connector.className = connector.className.replace(/bg-\S+/g, "").trim()
          connector.classList.add(prevCompleted ? "bg-brand-solid" : "bg-secondary")
        } else {
          // Right connector: completed if this step is completed
          const thisCompleted = stepIndex < current
          connector.className = connector.className.replace(/bg-\S+/g, "").trim()
          connector.classList.add(thisCompleted ? "bg-brand-solid" : "bg-secondary")
        }
      })
    })

    // Update step labels (title colors)
    const labels = this.element.querySelectorAll("nav > div > div.mt-3")
    labels.forEach((label, i) => {
      const stepIndex = i + 1
      const title = label.querySelector("p:first-child")
      const desc = label.querySelector("p:last-child")

      if (title) {
        title.classList.remove("text-tertiary", "text-brand-secondary")
        title.classList.add(stepIndex === current || stepIndex < current ? "text-brand-secondary" : "text-tertiary")
      }
      if (desc && desc !== title) {
        desc.classList.remove("text-quaternary", "text-tertiary")
        desc.classList.add(stepIndex === current || stepIndex < current ? "text-tertiary" : "text-quaternary")
      }
    })

    // Update prev button visibility
    if (this.hasPrevButtonTarget) {
      if (current <= 1) {
        this.prevButtonTarget.classList.add("invisible")
      } else {
        this.prevButtonTarget.classList.remove("invisible")
      }
    }

    // Update next/finish button visibility
    if (this.hasNextButtonTarget) {
      if (current >= total) {
        this.nextButtonTarget.classList.add("hidden")
      } else {
        this.nextButtonTarget.classList.remove("hidden")
      }
    }

    if (this.hasFinishButtonTarget) {
      if (current >= total) {
        this.finishButtonTarget.classList.remove("hidden")
      } else {
        this.finishButtonTarget.classList.add("hidden")
      }
    }

    // Update step counter text
    if (this.hasStepCounterTarget) {
      this.stepCounterTarget.textContent = `Step ${current} of ${total}`
    }
  }
}
