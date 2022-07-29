# 5. Application errors when the Academy API errors

Date: 2022-07-15

## Status

Accepted

## Context

Right now the application is wholly reliant on the 'Academies API' aka 'TRAMS
Data API' aka 'Prepare API' [1] to render almost all requests. In the case of a
failure the application could try to render the data it can retrieve, there
would be little value to the user in doing so.

There is very little technical or governance documentation for the 'Academies
Database' that the API exposes which means our team has a lack of confidence in
the data our application relies upon. Right now the team does not know how and
when the data is modified and by whom.

The team feel they have three options when faced with API errors:

1. The application errors when the API errors
2. The application attempts to render a request even when the API errors
3. The application copies the data into the application to free the application
   from being reliant on the API

[1] https://github.com/DFE-Digital/trams-data-api

## Decision

Attempting to render a request without the data from the API will make the
application of little value to users so is not a viable solution.

Copying the data causes duplication of both the data and the effort to maintain
it which is risky, there may be legitimate reasons that the data changes and we
should understand and reflect those. There is also greater value in 'single
source of truths' that APIs such as these provide.

At this point in delivery the decision is:

- If the Academies API fails to respond or raises a connection error, our
  application will also error.
- If a data object cannot be found i.e. the API returns 404 for an object our
  application has previously used, our application will also error.

The application will validate the data objects exist at the time it creates its
own internal representations so it has done its own due diligence.

The team will track the errors raised to build their understanding of the
Academies Database and to assist the team who own it to improve documentation
and governance moving forwards.

## Consequences

Any errors or performance issues present in the Academies API will be passed on
to our application. The team will use these errors to learn how and when they
occur and look to work with other teams to mitigate them.
