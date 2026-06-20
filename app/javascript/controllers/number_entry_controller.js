import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "date", "value", "dateLabel"]
  static values = { open: Boolean }

  connect() {
    if (this.openValue) this.show()
  }

  open(event) {
    event.preventDefault()
    this.dateTarget.value = event.currentTarget.dataset.date
    this.dateLabelTarget.textContent = event.currentTarget.dataset.dateLabel
    this.valueTarget.value = ""

    this.show()
    this.valueTarget.focus()
  }

  close() {
    this.dialogTarget.close()
  }

  closeOnBackdrop(event) {
    if (event.target === this.dialogTarget) this.close()
  }

  stopPropagation(event) {
    event.stopPropagation()
  }

  show() {
    if (!this.dialogTarget.open) this.dialogTarget.showModal()
  }
}
