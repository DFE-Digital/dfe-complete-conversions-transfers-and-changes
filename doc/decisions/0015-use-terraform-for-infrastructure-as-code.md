# 15. Use Terraform for infrastructure as code

Date: 2022-12-14

## Status

Accepted

## Context

Having a robust, repeatable and well documented infrastructure is vital for any
digital service. The best way of achieving this is through infrastructure as
code, the benefits of which are outlined in this article:

https://www.martinfowler.com/bliki/InfrastructureAsCode.html

Terraform and Azure Resource Manager (ARM) are the recommended tool in the DfE
Technical Guidance for managing infrastructure as code:

https://technical-guidance.education.gov.uk/guides/default-technology-stack/#infrastructure-as-code

## Decision

As Terraform is an abstraction over specific vendors, as well as being the tool
of choice of the service technical operations team, it makes sense for us to
make use of the technology.

All our infrastructure will be managed using Terraform, with the code committed
to the repository or via a Terraform module managed at the service level.

## Consequences

- Robust, repeatable and documented infrastructure for our product
- Retainable knowledge of Terraform will be required by the service team
- Knowledge of Terraform will be required in the product team
