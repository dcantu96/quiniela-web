import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["filter"];

  filter() {
    const url = `${window.location.pathname}?${this.params}`;

    Turbolinks.clearCache();
    Turbolinks.visit(url);
  }

  get params() {
    let checkedBoxes = this.filterTargets.filter(t => t.getAttribute('type') === 'checkbox' && t.checked)
    let otherParams = this.filterTargets.filter(t => t.getAttribute('type') !== 'checkbox' && t.value !== "")
    return otherParams.concat(checkedBoxes).map(t => `${t.name}=${t.value}` ).join("&");
  }
}