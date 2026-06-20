import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["chooser", "form", "type", "unit", "heading", "name"]

  select(event) {
    event.preventDefault()
    const type = event.currentTarget.dataset.habitType

    this.typeTarget.value = type
    this.headingTarget.textContent = type === "number" ? "Create a number habit" : "Create a checkbox habit"
    this.unitTarget.hidden = type !== "number"
    this.unitTarget.querySelector("input").required = type === "number"
    this.chooserTarget.hidden = true
    this.formTarget.hidden = false
    this.nameTarget.focus()
  }

  back() {
    this.formTarget.hidden = true
    this.chooserTarget.hidden = false
  }
}
