import { Controller } from 'stimulus'
import Select2 from 'select2'
import 'select2/dist/css/select2.css'
import $ from 'jquery';

export default class extends Controller {
	connect() {
    $('.select2').select2();
  }
}
