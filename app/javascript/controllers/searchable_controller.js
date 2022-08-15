import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['filter', 'member']

  search(event) {
    let filter = event.target.value.toUpperCase()
    for (let member of this.targets.findAll('member')) {
      if (member.dataset.username.toUpperCase().indexOf(filter) > -1) {
        member.style.display = "";
      } else {
        member.style.display = "none";
      }
    }
  }
}