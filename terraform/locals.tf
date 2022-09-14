locals {
  environment                     = var.environment
  project_name                    = var.project_name
  azure_location                  = var.azure_location
  enable_container_registry       = var.enable_container_registry
  image_name                      = var.image_name
  container_command               = var.container_command
  container_environment_variables = var.container_environment_variables
  enable_mssql_database           = var.enable_mssql_database
  mssql_server_admin_password     = var.mssql_server_admin_password
  mssql_database_name             = var.mssql_database_name
}
