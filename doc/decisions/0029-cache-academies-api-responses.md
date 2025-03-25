# 29. Cache Academies API responses

Date: 2025-03-24

## Status

Accepted

## Context

The Complete service (Ruby) makes many connections to the [Academies API][] (See
[OpenAPI / Swagger][]). Sometimes these connections time out or are refused, presumably
due to their volume.

For example we saw 25 timeouts on the morning of 10/03/2025 compared to 3,049
successful requests. We handle these gracefully with a user-friendly error page:

`Net::OpenTimeout -> rescued with pages/academies_api_client_timeout`

but these errors and the general slow performance (95th percentile around 1
second) make for a decidedly poor user experience.

## Decision

The data which we retrieve describes Establishments (schools) and Trusts. It
changes very rarely and can be cached for long periods.

We will introduce caching in our application within the HTTP client
communicating with the upstream Academies API. Ideally that APIs responses would
include caching headers such as:

- `Cache-Control` e.g.
  - `max-age` / `s-maxage`
  - `must-revalidate`
- `Age`
- `Last-Modified`
- `ETag`
- `Expires`

allowing us to use existing libraries such as ([faraday-http-cache][]) as
middleware in our Faraday HTTP client without the need to implement our own
caching functionality.

However as a tactical solution we will implement our own caching using our
existing Redis infrastructure. We will do this by introducing a new
`CachedConnection`. The `AcademiesApi::Client` will be altered to collaborate
with this class rather than calling the `Faraday::Connection` (the HTTP client)
directly.

## Consequences

We expect to see greatly improved performance generally as a result of caching
the responses from this API which is used for all representations of Conversions
and Transfers. We hope to see the elimination of the API timeouts and connection
refusals.

It's possible that we will have to make adjustments to our cache expiration
strategy if we find that stale data is a problem. For instance, when a UKPRN is
allocated to a new trust (Form a Multi-Academy Trust) the new UKPRN is added to
GIAS and then to Academies API from where it becomes available to Complete. In
this scenario we might have to wait for a cache expiration (currently planned at
a max of 24 hours) before the UKPRN is seen in Complete.

[Academies API]: https://github.com/DFE-Digital/academies-api
[OpenAPI / Swagger]:
  https://api.academies.education.gov.uk/swagger/index.html?urls.primaryName=V4
[MDN info on response headers]:
  https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers
[faraday-http-cache]: https://github.com/sourcelevel/faraday-http-cache
