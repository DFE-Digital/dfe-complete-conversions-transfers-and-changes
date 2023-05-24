module "azure_container_apps_hosting" {
  source = "github.com/DFE-Digital/terraform-azurerm-container-apps-hosting?ref=v0.17.4"

  environment    = local.environment
  project_name   = local.project_name
  azure_location = local.azure_location
  tags           = local.tags

  virtual_network_address_space = local.virtual_network_address_space

  enable_container_registry = local.enable_container_registry

  image_name                             = local.image_name
  container_command                      = local.container_command
  container_secret_environment_variables = local.container_secret_environment_variables

  enable_worker_container  = local.enable_worker_container
  worker_container_command = local.worker_container_command

  enable_event_hub = local.enable_event_hub

  enable_mssql_database = local.enable_mssql_database

  enable_redis_cache = local.enable_redis_cache

  enable_cdn_frontdoor                      = local.enable_cdn_frontdoor
  enable_cdn_frontdoor_health_probe         = local.enable_cdn_frontdoor_health_probe
  cdn_frontdoor_origin_fqdn_override        = local.cdn_frontdoor_origin_fqdn_override
  cdn_frontdoor_origin_host_header_override = local.cdn_frontdoor_origin_host_header_override
  cdn_frontdoor_custom_domains              = local.cdn_frontdoor_custom_domains
  cdn_frontdoor_host_redirects              = local.cdn_frontdoor_host_redirects
  cdn_frontdoor_enable_rate_limiting        = local.cdn_frontdoor_enable_rate_limiting
  cdn_frontdoor_rate_limiting_threshold     = local.cdn_frontdoor_rate_limiting_threshold

  enable_dns_zone      = local.enable_dns_zone
  dns_zone_domain_name = local.dns_zone_domain_name
  dns_ns_records       = local.dns_ns_records
  dns_txt_records      = local.dns_txt_records

  enable_monitoring               = local.enable_monitoring
  monitor_email_receivers         = local.monitor_email_receivers
  enable_container_health_probe   = local.enable_container_health_probe
  container_health_probe_protocol = local.container_health_probe_protocol
  monitor_endpoint_healthcheck    = local.monitor_endpoint_healthcheck
  monitor_enable_slack_webhook    = local.monitor_enable_slack_webhook
  monitor_slack_webhook_receiver  = local.monitor_slack_webhook_receiver
  monitor_slack_channel           = local.monitor_slack_channel

  existing_network_watcher_name                = local.existing_network_watcher_name
  existing_network_watcher_resource_group_name = local.existing_network_watcher_resource_group_name
}
