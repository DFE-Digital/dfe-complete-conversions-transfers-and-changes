locals {
  environment                                  = var.environment
  project_name                                 = var.project_name
  azure_location                               = var.azure_location
  tags                                         = var.tags
  virtual_network_address_space                = var.virtual_network_address_space
  enable_container_registry                    = var.enable_container_registry
  image_name                                   = var.image_name
  container_command                            = var.container_command
  container_secret_environment_variables       = var.container_secret_environment_variables
  enable_worker_container                      = var.enable_worker_container
  worker_container_command                     = var.worker_container_command
  enable_mssql_database                        = var.enable_mssql_database
  enable_redis_cache                           = var.enable_redis_cache
  enable_cdn_frontdoor                         = var.enable_cdn_frontdoor
  enable_event_hub                             = var.enable_event_hub
  cdn_frontdoor_custom_domains                 = var.cdn_frontdoor_custom_domains
  cdn_frontdoor_origin_fqdn_override           = var.cdn_frontdoor_origin_fqdn_override
  cdn_frontdoor_host_redirects                 = var.cdn_frontdoor_host_redirects
  cdn_frontdoor_enable_rate_limiting           = var.cdn_frontdoor_enable_rate_limiting
  cdn_frontdoor_rate_limiting_threshold        = var.cdn_frontdoor_rate_limiting_threshold
  enable_dns_zone                              = var.enable_dns_zone
  dns_zone_domain_name                         = var.dns_zone_domain_name
  dns_ns_records                               = var.dns_ns_records
  dns_txt_records                              = var.dns_txt_records
  key_vault_access_users                       = toset(var.key_vault_access_users)
  tfvars_filename                              = var.tfvars_filename
  enable_monitoring                            = var.enable_monitoring
  monitor_email_receivers                      = var.monitor_email_receivers
  enable_container_health_probe                = var.enable_container_health_probe
  container_health_probe_protocol              = var.container_health_probe_protocol
  cdn_frontdoor_health_probe_path              = var.cdn_frontdoor_health_probe_path
  monitor_endpoint_healthcheck                 = var.monitor_endpoint_healthcheck
  monitor_enable_slack_webhook                 = var.monitor_enable_slack_webhook
  monitor_slack_webhook_receiver               = var.monitor_slack_webhook_receiver
  monitor_slack_channel                        = var.monitor_slack_channel
  existing_network_watcher_name                = var.existing_network_watcher_name
  existing_network_watcher_resource_group_name = var.existing_network_watcher_resource_group_name
}
