import { UserAutocomplete } from './user_autocomplete.js'

// Entry point for the build script in your package.json
//
const govukInitialiser = window.GOVUKFrontend.initAll
govukInitialiser()

// check for the appropriate element and progressively enchance to a autocomplete when
// found
const assignToTarget = document.getElementById('assignment-form-group')
if (assignToTarget) {
  const autocomplete = new UserAutocomplete()
  autocomplete.init(
    assignToTarget.id,
    'internal_contacts_edit_assigned_user_form[email]',
    'Assign to'
  )
}

const addedByTarget = document.getElementById('added-by-form-group')
if (addedByTarget) {
  const autocomplete = new UserAutocomplete()
  autocomplete.init(
    addedByTarget.id,
    'internal_contacts_edit_added_by_user_form[email]',
    'Added by'
  )
}
