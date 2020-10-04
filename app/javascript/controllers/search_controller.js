import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['results'];

  search(event) {
    let queryTerm = event.target.value
    if (queryTerm === '') {
      return this.resultsTarget.innerHTML = ''
    }
    if (queryTerm.length > 2) {
      let url = `${this.data.get('url')}?q=${queryTerm}`
      this.resultsTarget.innerHTML = `<div class='p-2'>Searching...</div>`
      this.fetchAutocomplete(url)
    }
  }

  fetchAutocomplete(url) {
    Rails.ajax({
      type: 'GET',
      url: url,
      dataType: 'json',
      success: (data) => {
        if (data.results.length === 0) {
          this.resultsTarget.innerHTML = `<div class='p-2'>No results found</div>`
        } else {
          this.resultsTarget.innerHTML = data.results
        }
      },
      error: () => {
        this.resultsTarget.innerHTML = `<div class='p-2'>Error</div>`
      }
    })
  }


}
