import { Application } from "@hotwired/stimulus"
import jQuery from "jquery"
import toaster from "sweetalert2"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application
window.jQuery = jQuery // <- "select2" will check this
window.$ = jQuery
window.toaster = toaster

export { application }