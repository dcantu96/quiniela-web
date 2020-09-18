import {Controller} from 'stimulus'

export default class extends Controller {
  static targets = ['filter', 'tablebody']

  search(event) {
    let filter = event.target.value.toUpperCase();

    for (let row of this.tablebodyTarget.rows) {
      let txtValue = row.cells[0].textContent || row.cells[0].innerText;
      if (txtValue.toUpperCase().indexOf(filter) > -1) {
        row.style.display = "";
      } else {
        row.style.display = "none";
      }
    }
  }
}