resource "azurerm_container_registry" "acr" {
  name                = local.resource_prefix
  resource_group_name = data.azurerm_resource_group.default.name
  location            = local.azure_region
  sku                 = "Standard"
  admin_enabled       = true

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
