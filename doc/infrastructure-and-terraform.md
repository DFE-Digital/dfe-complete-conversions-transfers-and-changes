# Infrastructure and Terraform

We use infrastructure as code ([Terraform](https://www.terraform.io/)) to deploy
and manage resources hosting the app. This is stored in the `terraform`
directory.

Read the [In-depth Terraform documentation](/terraform/README.md)

## Linting Terraform documentation

Occasionally, a PR might fail CI on Github at the Terraform / Validate
step. To lint the Terraform documentation and get this check passing:

1. Install terraform-docs `brew install terraform-docs`
1. Switch onto the failing branch (usually a Renovate branch)
1. `cd` into the terraform directory in the repo
1. Run `terrform-docs .`
1. Commit the changes on the branch

## Tfvar files

We use `tfvar` files to store the secrets and settings used to manage our
infrastructure.

Each environment has a corresponding file, `dev.tfvars`, `test.tfvars` and
`prod.tfvars`.

As the contents of these files is sensitive, we have to handle them carefully
and store them securely.

These files should never be shared via insecure methods and are stored in the
Azure Keyvault.

If you need to work with the infrastructure, for example updating or adding an
environment variable, you will need to fetch the relevant file.

### Fetching the tfvar files

Before you can fetch the files you need permission to do so. Another member of
the team or a member of the devops team will need to action this for you.

Each file has a `key_vault_access_users` key which is an array of the user
accounts that can download the files. Your account will need to be added to this
list and have the change applied before you can then download the files.

The keyvault that stores these files is in the `development` Azure resource
group so you will not neeed to open a PIM to download the files, note: you will
need a PIM to apply any changes in `test` or `production`.

Once you have access you can download the files for each environment.

Instructions for downloading the files will be available in the
[wiki (DfE access required)](https://dfe-gov-uk.visualstudio.com/Academies-and-Free-Schools-SIP/_wiki?pageId=3888&friendlyName=DevOps-Documentation#)]

Applying changes with the `tfvar` file will also update the file stored in the
Azure keyvault:

**_Always download the `tfvars` before running any Terraform to ensure you have
the latest version!_**

See the [in-depth Terraform documentation](/terraform/README.md) for applying
changes with these files.
