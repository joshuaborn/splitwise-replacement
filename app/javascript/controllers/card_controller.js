
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="card"
export default class extends Controller {
  static targets = [ "form" ]

  submit() {
    this.formTarget.submit()
  }
}
