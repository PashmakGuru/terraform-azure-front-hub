output "name_servers" {
  value = {
    for key, zone in azurerm_dns_zone.this : key => zone.name_servers
  }
}
