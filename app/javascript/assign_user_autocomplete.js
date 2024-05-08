import accessibleAutocomplete from 'accessible-autocomplete'
// AssignUserAutocomplete
//
// Use:
//
// autocomplete = new AssignUserAutocomplete
// autocomplete.init('#id-of-outer-div')
export class AssignUserAutocomplete {
  constructor () {
    this.initialEmail = ''
  }

  format = (user) => {
    return `${user[0]} ${user[1]} (${user[2]})`
  }

  // removes the fallback field, grabbing the value from it first and then creates and adds the
  // autocomplete
  switchToAutocomplete = (element) => {
    // get the initial email address
    this.initialEmail = document.querySelector(`#${element} > div > input`).value

    // remove the existing form group
    const container = document.getElementById(element)
    document.querySelector(`#${element} > div`).remove()

    // add the autocomplete elements
    container.innerHTML += '<div class="govuk-form-group"></div>'
    const formGroup = document.querySelector('.govuk-form-group')
    formGroup.innerHTML += '<label for="assign-user-autocomplete" class="govuk-label govuk-label--m">Assign to</label>'
    formGroup.innerHTML += '<div id="assign-user-autocomplete-target" class="govuk-!-width-three-quarters"></div>'

    // we have to include a hidden field to actually submit the email
    // this hidden field has to conform to Rails conventions
    formGroup.innerHTML += '<input type="hidden" name="internal_contacts_edit_assigned_user_form[email]" id="new-email-value">'
  }

  // return a formatted suggestion
  // when using a defualtValue we have to watch out for the initial suggestion being a string,
  // this could be a bug/feature of the autocomplete that others have found, when the autocomplete is
  // suggesting it is a object (array)
  formatSuggestion = (suggestion) => {
    if (suggestion) {
      if (typeof (suggestion) === 'string') return suggestion

      return this.format(suggestion)
    }
  }

  // return a formatted value to show in the text field, like suggestions, we have to watch for strings
  // and not try to format those.
  formatInputValue = (option) => {
    if (option) {
      if (typeof (option) === 'string') return option

      return this.format(option)
    }
  }

  // update the hidden field to keep it insync with the autocomplete, this field value is what is
  // submitted
  updateSubmittingValue = (option) => {
    if (option) {
      document.querySelector('#new-email-value').value = option[2]
    }
  }

  // when we load the form and switch to the autocomplete we only have the email address, this method
  // turns that into a user and returns a formatted value
  emailToUser = async (email) => {
    if (!email) return

    const response = await fetch('/search/user?query=' + email)
    const results = await response.json()
    const user = results[0]
    this.updateSubmittingValue(user)
    return this.format(user)
  }

  // the main suggestion method calls the endpoint and populates the suggestion list
  suggest = async (query, populateResults) => {
    if (query) {
      const response = await fetch('/search/user?type=assignable&query=' + query)
      const results = await response.json()
      populateResults(results)
    }
  }

  // main initialisation of the object, switches the form element to the autocomplete
  init = async (element) => {
    this.switchToAutocomplete(element)

    accessibleAutocomplete({
      element: document.querySelector('#assign-user-autocomplete-target'),
      id: 'assign-user-autocomplete',
      source: this.suggest,
      minLength: 3,
      onConfirm: this.updateSubmittingValue,
      confirmOnBlur: false,
      autoselect: true,
      templates: {
        inputValue: this.formatInputValue,
        suggestion: this.formatSuggestion
      },
      defaultValue: await this.emailToUser(this.initialEmail)
    })
  }
}
