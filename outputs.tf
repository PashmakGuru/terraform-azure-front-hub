output "name_servers" {
  value = {
    for key, zone in azurerm_dns_zone.this : key => zone.name_servers
  }
}

output "urls" {
    value = {
        for endpointName, endpoint in azurerm_cdn_frontdoor_endpoint.this:
            endpointName => {
                # TODO: Add a unique identifier
                host_name: endpoint.host_name
            }
    }
}
