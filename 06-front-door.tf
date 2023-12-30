resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = "main"
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "Standard_AzureFrontDoor"
}

# resource "azurerm_cdn_frontdoor_custom_domain" "example" {
#   name                     = "cd-test-1.pashmak.guru"
#   cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id
#   dns_zone_id              = azurerm_dns_zone.this.id
#   host_name                = "test-1.pashmak.guru"

#   tls {
#     certificate_type    = "ManagedCertificate"
#     minimum_tls_version = "TLS12"
#   }
# }

resource "azurerm_cdn_frontdoor_origin_group" "this" {
  for_each                                                  = toset(var.origin_groups)
  name                                                      = each.key
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.this.id
  session_affinity_enabled                                  = true
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 1

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 16
    successful_samples_required        = 3
  }
}

data "azurerm_public_ips" "this" {
  for_each            = var.public_ip_origins
  resource_group_name = each.value.pip_resource_group_name
  name_prefix         = each.value.pip_name_prefix
}

resource "azurerm_cdn_frontdoor_origin" "this" {
  for_each                      = var.public_ip_origins
  name                          = each.key
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this[each.value.origin_group_name].id
  enabled                       = true

  certificate_name_check_enabled = true

  host_name          = data.azurerm_public_ips.this[each.key].public_ips[0].ip_address
  http_port          = 80
  https_port         = 443
  origin_host_header = each.value.origin_host_header
}

resource "azurerm_cdn_frontdoor_endpoint" "this" {
  for_each                 = toset(var.endpoints)
  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
}

resource "azurerm_cdn_frontdoor_rule_set" "this" {
  for_each                 = toset(var.rule_sets)
  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
}

resource "azurerm_cdn_frontdoor_route" "this" {
  for_each                      = var.routes
  name                          = each.key
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.this[each.value.endpoint_name].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this[each.value.origin_group_name].id
  cdn_frontdoor_origin_ids = [
    for name in each.value.origin_names : azurerm_cdn_frontdoor_origin.this[name].id
  ]
  cdn_frontdoor_rule_set_ids = [
    for name in each.value.rule_set_names : azurerm_cdn_frontdoor_rule_set.this[name].id
  ]
  enabled = true

  forwarding_protocol    = "HttpOnly"
  patterns_to_match      = each.value.patterns_to_match
  supported_protocols    = ["Http", "Https"]
  https_redirect_enabled = true

  #cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.contoso.id, azurerm_cdn_frontdoor_custom_domain.fabrikam.id]
  link_to_default_domain = each.value.use_azure_domain
}
