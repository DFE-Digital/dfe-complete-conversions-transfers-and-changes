function googleTagManagerScript (window, document, script, datalayer, id) {
  // Retrieve datalayer array from window scope or create an empty array if it doesn't exist
  window[datalayer] = window[datalayer] || []

  // Push a timestamped event for GTM initialisation
  window[datalayer].push({
    'gtm.start': new Date().getTime(),
    event: 'gtm.js'
  })

  // Get the first script included on the page
  const firstScript = document.getElementsByTagName(script)[0]

  // Create a script element
  const gtmScript = document.createElement(script)

  // Optionally prepare the query parameter string for the datalayer name
  const dataLayerParam = datalayer !== 'dataLayer' ? '&l=' + datalayer : ''

  // Enable asynchronous loading for the GTM script
  gtmScript.async = true

  // Finalise link to GTM script
  gtmScript.src = '//www.googletagmanager.com/gtm.js?id=' + id + dataLayerParam

  // Insert new script element into DOM
  firstScript.parentNode.insertBefore(gtmScript, firstScript)
}

// Get the id form the meta tag
const tagManagerId = document.head.querySelector('meta[name="google-tag-manager-connection"]').content

// load the Tag Manager script and fire it
googleTagManagerScript(window, document, 'script', 'datalayer', tagManagerId)
