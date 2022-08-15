import { Controller } from "@hotwired/stimulus"
import Sortable from 'sortablejs'
import swal from 'sweetalert2'

export default class extends Controller {
	connect() {
		this.sortable = Sortable.create(this.element, {
      group: 'stages',
      sort: true,
      direction: 'horizontal',
      animation: 250,
      onEnd: this.end.bind(this),
      swapThreshold: 0.5,
    })
	}

	end(event) {
    const Toast = swal.mixin({
      toast: true,
      position: 'top-end',
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true,
      onOpen: (toast) => {
        toast.addEventListener('mouseenter', swal.stopTimer)
        toast.addEventListener('mouseleave', swal.resumeTimer)
      }
    })

    let id = event.item.dataset.id
    let data = new FormData()
    data.append("position", event.newIndex + 1)

    Rails.ajax({
      url: this.data.get("url").replace(":id", id),
      type: 'PATCH',
      data: data,
      success: () => {
        Toast.fire({
          icon: 'success',
          title: `Se actualizó la posición de la etapa ${event.item.innerText}`
        })
      },
      error: () => {
        Toast.fire({
          icon: 'success',
          title: `No se pudo actualizar la posición de la etapa ${event.item.innerText}`
        })
      }
    })
  }
}
