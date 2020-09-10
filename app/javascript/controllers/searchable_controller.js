import {Controller} from 'stimulus'

export default class extends Controller {
  static targets = ['filter', 'rows']

  search(event) {
    var searchValue = $.trim(event.target.value).replace(/ +/g, ' ').toLowerCase();

    $('#table-rows tr').show().filter(function() {
      var username = $('td:first', this).text().replace(/\s+/g, ' ').toLowerCase();
      return !~username.indexOf(searchValue);
    }).hide();
  }
}