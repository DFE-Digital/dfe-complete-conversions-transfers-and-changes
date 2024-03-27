# Information Banner

We sometimes want to inform all users of something important, scheduled downtime
for example.

To do so we have an Information banner that can be enabled and is then shown
across the application.

To set the content of the banner:

- locate the `config/locales/information_banner.yml` locale file
- update the `title`
- update the HTML used for the `body`
- commit, merge and deploy this change

Then:

- set the `SHOW_INFORMATION_BANNER` environment variable to `true`
