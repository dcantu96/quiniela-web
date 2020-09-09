// Load all the controllers within this directory and all subdirectories. 
// Controller files must be named *_controller.js.
window.jQuery = window.$ = require('jquery')
require('datatables.net')

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
import Datatable from 'stimulus-datatables'

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
application.register('datatable', Datatable)
application.load(definitionsFromContext(context))
