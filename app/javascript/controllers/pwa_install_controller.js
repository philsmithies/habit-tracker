import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["instructions"]

  connect() {
    const isIOS = /iphone|ipad|ipod/i.test(navigator.userAgent)
    const isStandalone = window.matchMedia("(display-mode: standalone)").matches || navigator.standalone

    this.instructionsTarget.hidden = !isIOS || isStandalone
  }
}
