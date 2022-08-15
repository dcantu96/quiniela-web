import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['tab', 'tabPanel'];
	connect() {
    this.showTab()
  }

  change(e) {
    this.index = this.tabTargets.indexOf(e.target)
    this.showTab(this.index)
  }

  showTab() {
    this.tabPanelTargets.forEach((el, i) => {
      console.log(el)
      console.log(this.index)
      if (i == this.index) {
        el.classList.remove('hidden')
        el.classList.add('grid')
      } else {
        el.classList.remove('grid')
        el.classList.add('hidden')
      }
    })

    this.tabTargets.forEach((el, i) => {
      if (i == this.index) {
        el.classList.add('bg-orange-200')
      } else {
        el.classList.remove('bg-orange-200')
      }
    })
  }

  get index() {
    return parseInt(this.data.get('index'))
  }

  set index(value) {
    this.data.set("index", value)
    this.showTab()
  }

}
