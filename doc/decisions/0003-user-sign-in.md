# 3. User sign in

Date: 2022-06-28

## Status

Accepted

## Context

Our application will require users to sign in. Doing so allows us to meet both
user and business needs such as personalisation and data security.

DfE already has an Active Directory service running in Azure. Our first user
group will have accounts in the directory as part of the their DfE onboarding.

Connecting to and utilising an existing authorisation service like this reduces
the amount of effort required from our team.

## Decision

Our Rails app will connect to the DfE Active Directory to authorise users via
Oauth2.

We will use off the shelf gems to achieve this in the Rails application:

- Omniauth https://github.com/omniauth/omniauth
- Omniauth Microsoft Azure Active Directory
  https://github.com/RIPGlobal/omniauth-azure-activedirectory-v2

We chose the Microsoft Azure Active Directory strategy as we want to use single
tenant mode, so that only DfE users can authenticate and because it is the most
up-to-date fork of the original Microsoft gem.

## Consequences

DfE users are required to have a DfE Microsoft account.

For the majority of users, the authentication will have already occurred and
will be a familiar experience if it is required.

Setting up and maintaining the access to the Active Directory in Azure. This
will be minimal as it already exists and most of the work will be carried out
during initial development.

Potential for any DfE user to authenticate to the application, mitigated by
storing 'registered' users in the application. The list of registered users will
initially be managed by developers only, if prioritised, we can allow management
within the application later.
