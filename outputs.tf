output "name_servers" {
  value = {
    for key, zone in azurerm_dns_zone.this : key => zone.name_servers
  }
}

output "urls" {
    value = azurerm_cdn_frontdoor_endpoint.this.host_name
}
