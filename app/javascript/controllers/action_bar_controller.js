import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="action-bar"
export default class extends Controller {
    static targets = [ "enabledAdd", "disabledAdd" ]
    static values = [ "link" ]

    disableNewTransaction() {
        this.enabledAddTarget.style.display = "none"
        this.disabledAddTarget.style.display = ""
    }
    
    enableNewTransaction() {
        this.enabledAddTarget.style.display = ""
        this.disabledAddTarget.style.display = "none"
    }
}
