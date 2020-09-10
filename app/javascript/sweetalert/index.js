import swal from 'sweetalert2'
import Rails from '@rails/ujs'

Rails.confirm = function (message, element) {
  const swalCustomStyle = swal.mixin({
    customClass: {
      confirmButton: 'btn btn--success',
      cancelButton: 'btn btn--link'
    },
    buttonsStyling: false
  })

  swalCustomStyle.fire({
    title: 'Are you sure?',
    text: message,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes!',
    cancelButtonText: 'Back',
    reverseButtons: true
  }).then((result) => {
    if (result.value) {
      element.removeAttribute('data-confirm')
      element.click()
    }
  })
}
