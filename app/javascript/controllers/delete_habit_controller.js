import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "input", "submit"]
  static values = { name: String }

  open() {
    this.inputTarget.value = ""
    this.validate()
    this.dialogTarget.showModal()
    this.inputTarget.focus()
  }

  close(event) {
    event?.preventDefault()
    this.dialogTarget.close()
  }

  closeOnBackdrop(event) {
    if (event.target === this.dialogTarget) this.close()
  }

  stopPropagation(event) {
    event.stopPropagation()
  }

  validate() {
    this.submitTarget.disabled = this.inputTarget.value !== this.nameValue
  }
}
