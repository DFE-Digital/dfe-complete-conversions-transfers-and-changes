import { AssignUserAutocomplete } from './assign_user_autocomplete.js'

// Entry point for the build script in your package.json
//
const govukInitialiser = window.GOVUKFrontend.initAll
govukInitialiser()

// check for the appropriate element and progressively enchance to a autocomplete when
// found
const assignUserAutocomplete = document.getElementById('assignment-form-group')
if (assignUserAutocomplete) {
  const autocomplete = new AssignUserAutocomplete()
  autocomplete.init(assignUserAutocomplete.id)
}
