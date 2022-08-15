import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'button', 'popup' ]

  toggle(event) {
    event.preventDefault();

    if (this.buttonTarget.getAttribute('aria-expanded') == "false") {
        this.show();
    } else {
        this.hide(null);
    }
  }

  show() {
    this.buttonTarget.setAttribute('aria-expanded', 'true');
    this.popupTarget.classList.toggle('hidden');
  }

  hide(event) {

    this.buttonTarget.setAttribute('aria-expanded', 'false');
    this.popupTarget.classList.toggle('hidden');
  }
}