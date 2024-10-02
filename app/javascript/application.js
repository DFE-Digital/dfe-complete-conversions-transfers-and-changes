import { UserAutocomplete } from './user_autocomplete.js'

const govukInitialiser = window.GOVUKFrontend.initAll
govukInitialiser()

// check for the appropriate element and progressively enhance to a autocomplete when
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

const handoverByTarget = document.getElementById('handover-assign-form-group')
if (handoverByTarget) {
  const autocomplete = new UserAutocomplete()
  autocomplete.init(
    handoverByTarget.id,
    'new_handover_stepped_form[email]',
    'Who will complete this project?'
  )
}

// set the js-enabled class on the body if JS is enabled
document.body.className = ((document.body.className) ? document.body.className + ' js-enabled' : 'js-enabled')
