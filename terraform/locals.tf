locals {
  environment     = var.environment
  project_name    = var.project_name
  resource_prefix = "${local.environment}${local.project_name}"
  resource_group  = var.resource_group
  azure_region    = data.azurerm_resource_group.default.location
}
