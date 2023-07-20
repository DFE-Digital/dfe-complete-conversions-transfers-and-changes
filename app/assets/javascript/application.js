// include the DfE Frontend JS here
//= require dfefrontend
//
// Initialise the GOVUK Frontend
//
// It will only initialise components that are actually present on the page, see:
// `initAll()` https://github.com/alphagov/govuk-frontend/blob/89b4d21b595916cc477f4f1b12f7509a54735ded/package/govuk/all.js#L2831
//
var govuk_initialiser = window.GOVUKFrontend.initAll;
govuk_initialiser();
