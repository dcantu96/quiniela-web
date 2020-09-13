import {Controller} from 'stimulus'

export default class extends Controller {
  static targets = ['filter', 'rows']

  search(event) {
    var input, filter, tableRows, tr, td, i, txtValue;
    input = event.target;
    filter = input.value.toUpperCase();
    tableRows = document.getElementById("table-rows");
    tr = tableRows.getElementsByTagName("tr");
    for (i = 0; i < tr.length; i++) {
      td = tr[i].getElementsByTagName("th")[0];
      if (td) {
        txtValue = td.textContent || td.innerText;
        if (txtValue.toUpperCase().indexOf(filter) > -1) {
          tr[i].style.display = "";
        } else {
          tr[i].style.display = "none";
        }
      }       
    }
  }
}