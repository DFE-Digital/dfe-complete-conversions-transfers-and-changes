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
  enable_worker_container                = var.enable_worker_container
  worker_container_command               = var.worker_container_command
  enable_mssql_database                  = var.enable_mssql_database
  enable_redis_cache                     = var.enable_redis_cache
  enable_cdn_frontdoor                   = var.enable_cdn_frontdoor
  cdn_frontdoor_custom_domains           = var.cdn_frontdoor_custom_domains
  cdn_frontdoor_host_redirects           = var.cdn_frontdoor_host_redirects
  enable_dns_zone                        = var.enable_dns_zone
  dns_zone_domain_name                   = var.dns_zone_domain_name
  key_vault_access_users                 = toset(var.key_vault_access_users)
  tfvars_filename                        = var.tfvars_filename
  enable_monitoring                      = var.enable_monitoring
  monitor_email_receivers                = var.monitor_email_receivers
  enable_container_health_probe          = var.enable_container_health_probe
  cdn_frontdoor_health_probe_path        = var.cdn_frontdoor_health_probe_path
  monitor_endpoint_healthcheck           = var.monitor_endpoint_healthcheck
}
