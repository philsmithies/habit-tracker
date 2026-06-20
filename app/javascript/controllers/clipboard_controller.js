import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "button"]

  copy() {
    navigator.clipboard.writeText(this.sourceTarget.value)
    this.buttonTarget.textContent = "Copied"

    clearTimeout(this.resetTimer)
    this.resetTimer = setTimeout(() => {
      this.buttonTarget.textContent = "Copy code"
    }, 1500)
  }

  disconnect() {
    clearTimeout(this.resetTimer)
  }
}
