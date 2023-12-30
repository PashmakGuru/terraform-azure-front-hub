resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_dns_zone" "this" {
  for_each            = toset(var.zones)
  name                = each.value
  resource_group_name = azurerm_resource_group.this.name
}
