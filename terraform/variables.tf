variable "environment" {
  description = "Environment name. Will be used along with `project_name` as a prefix for all resources."
  type        = string
}

variable "key_vault_access_users" {
  description = "List of users that require access to the Key Vault where tfvars are stored. This should be a list of User Principle Names (Found in Active Directory) that need to run terraform"
  type        = list(string)
}

variable "tfvars_filename" {
  description = "tfvars filename. This file is uploaded and stored encrupted within Key Vault, to ensure that the latest tfvars are stored in a shared place."
  type        = string
}

variable "project_name" {
  description = "Project name. Will be used along with `environment` as a prefix for all resources."
  type        = string
}

variable "azure_location" {
  description = "Azure location in which to launch resources."
  type        = string
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
}

variable "virtual_network_address_space" {
  description = "Virtual network address space CIDR"
  type        = string
}

variable "enable_container_registry" {
  description = "Set to true to create a container registry"
  type        = bool
}

variable "image_name" {
  description = "Image name"
  type        = string
}

variable "container_command" {
  description = "Container command"
  type        = list(any)
}

variable "container_secret_environment_variables" {
  description = "Container secret environment variables"
  type        = map(string)
  sensitive   = true
}

variable "enable_mssql_database" {
  description = "Set to true to create an Azure SQL server/database, with aprivate endpoint within the virtual network"
  type        = bool
}

variable "enable_redis_cache" {
  description = "Set to true to create a Redis Cache"
  type        = bool
}

variable "enable_worker_container" {
  description = "Conditionally launch a worker container. This container uses the same image and environment variables as a the default container app, but allows a different container commanmd to be ran. The worker container does not expose any ports."
  type        = bool
}

variable "worker_container_command" {
  description = "Container command for the Worker container. `enable_worker_container` must be set to true for this to have any effect."
  type        = list(string)
}

variable "enable_cdn_frontdoor" {
  description = "Enable Azure CDN FrontDoor. This will use the Container Apps endpoint as the origin."
  type        = bool
}

variable "enable_dns_zone" {
  description = "Conditionally create a DNS zone"
  type        = bool
}

variable "dns_zone_domain_name" {
  description = "DNS zone domain name. If specified, records will automatically be created to point to the CDN."
  type        = string
}

variable "cdn_frontdoor_custom_domains" {
  description = "Azure CDN Front Door custom domains. If they are within the DNS zone (optionally created), the Validation TXT records and ALIAS/CNAME records will be created"
  type        = list(string)
  default     = []
}

variable "cdn_frontdoor_host_redirects" {
  description = "CDN Front Door host redirects `[{ \"from\" = \"example.com\", \"to\" = \"www.example.com\" }]`"
  type        = list(map(string))
  default     = []
}

variable "enable_monitoring" {
  description = "Create an App Insights instance and notification group for the Container App"
  type        = bool
}

variable "monitor_email_receivers" {
  description = "A list of email addresses that should be notified by monitoring alerts"
  type        = list(string)
}

variable "cdn_frontdoor_health_probe_path" {
  description = "Specifies the path relative to the origin that is used to determine the health of the origin."
  type        = string
}

variable "monitor_endpoint_healthcheck" {
  description = "Specify a route that should be monitored for a 200 OK status"
  type        = string
}

variable "enable_container_health_probe" {
  description = "Enable liveness probes for the Container"
  type        = bool
}

variable "monitor_enable_slack_webhook" {
  description = "Enable slack webhooks to send monitoring notifications to a channel"
  type        = bool
}

variable "monitor_slack_webhook_receiver" {
  description = "A Slack App webhook URL"
  type        = string
}

variable "monitor_slack_channel" {
  description = "Slack channel name/id to send messages to"
  type        = string
}
