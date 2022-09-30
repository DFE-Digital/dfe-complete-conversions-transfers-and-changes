locals {
  environment                            = var.environment
  project_name                           = var.project_name
  azure_location                         = var.azure_location
  tags                                   = var.tags
  virtual_network_address_space          = var.virtual_network_address_space
  enable_container_registry              = var.enable_container_registry
  image_name                             = var.image_name
  container_command                      = var.container_command
  container_secret_environment_variables = var.container_secret_environment_variables
  enable_mssql_database                  = var.enable_mssql_database
}
