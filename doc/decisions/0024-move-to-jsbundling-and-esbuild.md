# 24. Move to JSBundling and ESBuild

Date: 2024-05-02

## Status

Accepted

## Context

Up until now we have relied on very simple JavaScripts provided by:

- GOV.UK Fronend
- DfE Frontend
- Accessible Autocomplete

As we move forward we will need to write more and more complex JavaScript and
relying on the Rails Sprockets[1] asset pipeline for this will soon get
difficult.

The modern alternative is Rails JSBundling[2] along with a JS Bundler.

We've chosen to go with ESBuild as it has fast build times and almost no
configuration for our use case.

[1] https://github.com/rails/sprockets [2]
https://github.com/rails/jsbundling-rails [3] https://github.com/evanw/esbuild

## Decision

We'll use Rails JSBundling along with ESBuild to bundle our modern JavaScript
for the browser.

## Consequences

- developers will have to manage running the build process and the development
  server, although this is made simple with the scripts
- our browser support is now dictated by our ESBuild config, but we have no-JS
  fall-backs in place
