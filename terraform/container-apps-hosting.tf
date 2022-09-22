module "azure_container_apps_hosting" {
  source = "github.com/DFE-Digital/terraform-azurerm-container-apps-hosting?ref=v0.1.2"

  environment    = local.environment
  project_name   = local.project_name
  azure_location = local.azure_location

  enable_container_registry = local.enable_container_registry

  image_name                      = local.image_name
  container_command               = local.container_command
  container_environment_variables = local.container_environment_variables

  enable_mssql_database       = local.enable_mssql_database
  mssql_server_admin_password = local.mssql_server_admin_password
  mssql_database_name         = local.mssql_database_name
}
