# API consumption

The application consumes the follow API:

- The Academies API
- The Members API

## The Academies API

The Academies API is a DfE internal API.

The application uses it as a stand in for GIAS data as the
[GIAS API](https://dfe-developerhub.education.gov.uk/apis/GIASApi_V1) is not fit
for purpose at this time, to fetch establishment and trust details.

Establishment and trust details are required on almost every response, so the
application is 100% dependent on the API to return results.

`bulk` endpoints were added to the API to allow us to fetch multiple results as
a way to improve the performance of the API, but the team still find the API
relatively slow and it will often timeout.

We have a timeout period on the API set as an environment variable
(`ACADEMIES_API_TIMEOUT`) which is the maximum time the application will wait
for a response from the API.

We model a simple wrapper around the API and have 'fetcher' objects that allow
developers to add establishment and/or trust details to a already fetched set of
ActiveRecord `Projects` to increase performance.

The Academies API is private and we supply a secret to gain access, which is
stored in an environment variable (`ACADEMIES_API_KEY`) along with the API host.

For more details on the API visit
[the repository](https://github.com/DFE-Digital/academies-api)

## The Persons API

The Persons API is a DfE internal API, and is part of the Academies API.

The API is not used in production as the production API is not yet available,
once it is deployed we will use it to provide the contact details for the member
of parliament.

Two environment variables are required:

- `PERSONS_API_HOST`
- `PERSONS_API_KEY`

as both are different to the Academies API.

The data exposed on the API is managed centrally.

For more details on this API:

https://github.com/DFE-Digital/academies-api/tree/main/PersonsApi
