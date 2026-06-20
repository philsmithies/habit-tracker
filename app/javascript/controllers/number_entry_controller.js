import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "date", "value", "dateLabel"]

  open(event) {
    event.preventDefault()
    this.dateTarget.value = event.currentTarget.dataset.date
    this.dateLabelTarget.textContent = event.currentTarget.dataset.dateLabel
    this.valueTarget.value = ""

    if (typeof this.dialogTarget.showModal === "function") {
      this.dialogTarget.showModal()
    } else {
      this.dialogTarget.hidden = false
    }

    this.valueTarget.focus()
  }

  close() {
    if (typeof this.dialogTarget.close === "function") {
      this.dialogTarget.close()
    } else {
      this.dialogTarget.hidden = true
    }
  }

  closeOnBackdrop(event) {
    if (event.target === this.dialogTarget) this.close()
  }

  stopPropagation(event) {
    event.stopPropagation()
  }
}
