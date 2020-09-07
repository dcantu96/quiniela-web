import { Controller } from 'stimulus'
import Sortable from 'sortablejs'
import swal from 'sweetalert2'

export default class extends Controller {
	connect() {
		this.sortable = Sortable.create(this.element, {
      group: 'deal',
      direction: 'horizontal',
      animation: 250,
      swapThreshold: 0.85,
      filter: '.filtered',
      onEnd: this.end.bind(this),
    })
  }

  end(event) {
    let id = event.item.dataset.id
    let stageId = event.item.parentElement.dataset.stageId
    let input = event.item.getElementsByTagName("INPUT")[0]
    input.id = `deal_files_for_stage_${stageId}_ids_${id}`
    input.name = `deal[files_for][stage_${stageId}_ids][]`
    $('#other-files > div').each(function () {
      let otherFileRequirements = JSON.parse(this.dataset.requirements)
      let currentEventRequirements = JSON.parse(event.item.dataset.requirements)
      if (stageId === '0') {
        event.item.classList.remove('border-green-600');
        event.item.classList.remove('border-2');
        if (currentEventRequirements.length > 0) {
          for (var requirement of otherFileRequirements) {
            if (currentEventRequirements[0][0] !== requirement[0] && currentEventRequirements[0][1] === requirement[1]) {
              if (this.classList.contains('filtered')) {
                this.classList.remove('border-red-600');
                this.classList.remove('border-2');
                this.classList.remove('filtered');
              }
            }
          }
        }
      } else {
        event.item.classList.add('border-green-600');
        event.item.classList.add('border-2');
        if (currentEventRequirements.length > 0) {
          for (var requirement of otherFileRequirements) {
            if (currentEventRequirements[0][0] !== requirement[0] && currentEventRequirements[0][1] === requirement[1]) {
              if (!this.classList.contains('filtered')) {
                this.classList.add('border-red-600');
                this.classList.add('border-2');
                this.classList.add('filtered');
              }
            }
          }
        }
      }
    });
  }
}
