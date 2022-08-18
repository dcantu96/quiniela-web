pin "application", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@hotwired/turbo-rails", to: "https://ga.jspm.io/npm:@hotwired/turbo-rails@7.1.3/app/javascript/turbo/index.js"
pin "@hotwired/stimulus", to: "https://ga.jspm.io/npm:@hotwired/stimulus@3.1.0/dist/stimulus.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "stimulus-flatpickr", to: "https://ga.jspm.io/npm:stimulus-flatpickr@3.0.0-0/dist/index.m.js"
pin "flatpickr", to: "https://ga.jspm.io/npm:flatpickr@4.6.9/dist/flatpickr.js"
pin "stimulus-autocomplete", to: "https://ga.jspm.io/npm:stimulus-autocomplete@3.0.0-rc.5/src/autocomplete.js"

pin "@fortawesome/fontawesome-free", to: "https://ga.jspm.io/npm:@fortawesome/fontawesome-free@6.1.2/js/all.js"
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js", preload: true
pin "select2", to: "https://ga.jspm.io/npm:select2@4.1.0-rc.0/dist/js/select2.js"
pin "sweetalert2", to: "https://ga.jspm.io/npm:sweetalert2@11.4.26/dist/sweetalert2.all.js"
pin "@hotwired/turbo", to: "https://ga.jspm.io/npm:@hotwired/turbo@7.1.0/dist/turbo.es2017-esm.js"
pin "@rails/actioncable/src", to: "https://ga.jspm.io/npm:@rails/actioncable@7.0.3/src/index.js"