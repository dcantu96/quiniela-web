import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['entries', 'pagination', 'button']

  loadMore() {
    let next_page = this.paginationTarget.querySelector("a[rel='next']")
    if (next_page == null) { return }
    let url = next_page.href
    console.log(this.buttonTarget)
    this.buttonTarget.text = 'Loading ...'

    Rails.ajax({
      type: 'GET',
      url: url,
      dataType: 'json',
      success: (data) => {
        this.entriesTarget.insertAdjacentHTML('beforeend', data.entries)
        this.buttonTarget.text = 'Finished, Load More'
        this.paginationTarget.innerHTML = data.pagination
        let new_pagination = this.paginationTarget.querySelector("a[rel='next']")
        if (new_pagination == null) { 
          this.paginationTarget.remove()
          this.buttonTarget.remove()
        }
      },
      error: (data) => {
        this.buttonTarget.text = 'Failed to load, try again'
      }
    })
  }
}