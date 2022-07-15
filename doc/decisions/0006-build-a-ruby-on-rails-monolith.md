# 6. Build a Ruby on Rails monolith

Date: 2022-07-14

## Status

Accepted (Pending ratification by the DfE Technical Architecture board)

## Context

We decided to build a Rails monolith rather than a multi-tier application with a
.NET back-end in order to keep the application simple and enable the team to
deliver at pace, accepting the possible challenges with long-term sustainability
and interoperability with other RDD applications.

Most applications being built in RDD are multi-tier with a front-end on
GPaaS and a back-end API on Azure. Both the front-end and back-end are written
in .NET.

The Completions team has been building a Ruby on Rails monolith to date and
would like to continue with this.

### Monoliths and multi-tiered services

Monoliths are a common choice for small simple applications. They are typically
simpler to develop, deploy, and scale. However, as they become larger and
encompass more services and more logic they can become difficult to manage and
maintain, especially if different services are tightly coupled but being
developed at different paces. A monolith can offer an API, but this is not
enforced by the architecture. Splitting a monolith into tiers or microservices
enables each one to be developed and maintained independently and for teams and
individuals and teams to specialise on particular areas. It also enforces
creation of a standalone API that can be used by multiple front-ends and for
integration with other services. However, it comes at the cost of greater
overall system complexity which Martin Fowler describes as the
‘[microservice premium](https://www.martinfowler.com/bliki/MicroservicePremium.html):

> “Microservices are a useful architecture, but even their advocates say that
> using them incurs a significant Microservice Premium, which means they are only
> useful with more complex systems.  This premium, essentially the cost of
> managing a suite of services, will slow down a team, favoring a monolith for
> simpler applications.” [ref](https://www.martinfowler.com/bliki/MicroservicePremium.html)

His advice is therefore to take a
‘[monolith first](https://www.martinfowler.com/bliki/MonolithFirst.html)’
approach:

> “don't even consider microservices unless you have a system that's too complex
> to manage as a monolith. The majority of software systems should be built as a
> single monolithic application. Do pay attention to good modularity within that
> monolith, but don't try to separate it into separate services.”
> [ref](https://www.martinfowler.com/bliki/MicroservicePremium.html)

> “you should build a new application as a monolith initially, even if you think
> it's likely that it will benefit from a microservices architecture later on.”
> [ref](https://www.martinfowler.com/bliki/MonolithFirst.html)

> “Almost all the cases where I've heard of a system that was built as a
> microservice system from scratch, it has ended up in serious trouble.”
> [ref](https://www.martinfowler.com/bliki/MonolithFirst.html)

In the case of the Completions team, they are concerned that splitting the
application across two tiers means two codebases, with associated additional
governance and coordination to keep those codebases in sync, and that splitting
the application across two language stacks means adding at least one more
developer, with associated additional overhead for team management, and
challenges for tech lead in ensuring consistent quality code across in two
different languages. This additional complexity makes it harder to deliver at
pace.

The DfE Technical Guidance states that APIs are important:

> “APIs are an increasingly important part of DFE services. We are supporting an
> API first approach to help make our services highly operable and automated.
> API’s, however, should start with a need or a problem to solve.”
> [ref](https://technical-guidance.education.gov.uk/guides/api-guidance/#api-guidance-developing-a-dfe-api)

The requirement for APIs to be driven by needs or problems echoes one of the DfE
Technical Architecture Principles:

> “Design for user needs identified by research, not for generic reuse - that is
> premature optimisation.”
> [ref](https://technical-guidance.education.gov.uk/principles/architecture/#platforms-standards-and-re-use-emerge)

The convention within RDD is to build a separate back-end API in order to make
integrations easy and future-proof applications against future needs and
possible changes to front-end technologies. However, there is not a clearly
defined need at present, and no requirement that the API need be separate rather
than part of a monolith.

A multi-tiered approach is generally best suited for complex applications where
many front-ends make use of the same back-end API, or where performance is key.
Neither of these are key considerations for RDD in its current or expected
future state. This means RDD is not in a position to benefit from the principal
advantages of a multi-tier approach at present. This may change in future, and
this decision should be revisited at that point.

### Ruby on Rails

Ruby on Rails is one of the two core tech stacks supported by the DfE and they
are “equally well-supported in the department, and teams are encouraged to
select the stack that works best for them.”
[ref](https://technical-guidance.education.gov.uk/guides/default-technology-stack/#application-stacks)
Among DfE’s codebases on
[GitHub](https://github.com/orgs/DFE-Digital/repositories), there are ~90 in
Ruby on Rails and ~50 in .NET.

One of the principles of the [Rails Doctrine](https://rubyonrails.org/doctrine)
is ‘Convention over Configuration’, which means that codebases remain extremely
similar between different Rails applications created by different developers in
different environments. This makes it easier for developers to build a mental
model of the application to aid development, navigation, and debugging.

The Competitions team is made up primarily of Rails developers, but the
expertise within RDD is primarily in .NET and the division has had difficulty
recruiting Ruby developers in the past, which may make it difficult to maintain
a Ruby on Rails application in the long term.

## Decision

The Complete team will build a Rails monolith for the time being. The question
of tech stacks will be revisited with a focus on long-term sustainability after
the October deadline.

## Consequences

### Benefits

- Simplicity: The application is simpler, making it easier to build and
  maintain, and the team is smaller, making it easier to manage.
- Speed: The application can be iterated more quickly because there is no need
  to coordinate changes across two codebases.

### Challenges

- Sustainability: This approach breaks with convention, potentially making it
  harder to maintain in the long-run. We will need to take care in ensuring the
  application is well documented and to build internal capacity to maintain it.
- Interoperability: Since creation of an API is not architecturally enforced, we
  need to keep an eye out for any emerging user needs for an API and ensure that
  other applications can integrate with the service where necessary. If this is
  not done then there is a risk of reverting to using data pipelines for
  integration, which RDD wants to avoid.

What becomes easier or more difficult to do and any risks introduced by the
change that will need to be mitigated.
