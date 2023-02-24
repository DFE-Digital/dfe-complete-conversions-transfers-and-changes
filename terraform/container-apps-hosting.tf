module "azure_container_apps_hosting" {
  source = "github.com/DFE-Digital/terraform-azurerm-container-apps-hosting?ref=v0.14.3"

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

  enable_mssql_database = local.enable_mssql_database

  enable_redis_cache = local.enable_redis_cache

  enable_cdn_frontdoor         = local.enable_cdn_frontdoor
  cdn_frontdoor_custom_domains = local.cdn_frontdoor_custom_domains
  cdn_frontdoor_host_redirects = local.cdn_frontdoor_host_redirects

  enable_dns_zone      = local.enable_dns_zone
  dns_zone_domain_name = local.dns_zone_domain_name

  enable_monitoring               = local.enable_monitoring
  monitor_email_receivers         = local.monitor_email_receivers
  cdn_frontdoor_health_probe_path = local.cdn_frontdoor_health_probe_path
  container_health_probe_path     = local.container_health_probe_path
  monitor_endpoint_healthcheck    = local.monitor_endpoint_healthcheck
  monitor_enable_slack_webhook    = local.monitor_enable_slack_webhook
  monitor_slack_webhook_receiver  = local.monitor_slack_webhook_receiver
  monitor_slack_channel           = local.monitor_slack_channel
}
