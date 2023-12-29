locals {
  hostname = "argocd-test.pashmak.guru"
  hostname_slug = replace(local.hostname, ".", "-")
}

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
  name                     = "og-${local.hostname_slug}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  session_affinity_enabled = true
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 1

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 16
    successful_samples_required        = 3
  }
}

resource "azurerm_cdn_frontdoor_origin" "this" {
  name                          = "kubernetes-cluster-1"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this.id
  enabled                       = true

  certificate_name_check_enabled = true

  host_name          = "20.242.211.16"
  http_port          = 80
  https_port         = 443
  origin_host_header = local.hostname
}

resource "azurerm_cdn_frontdoor_endpoint" "this" {
  name                     = "ep-${local.hostname_slug}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
}

resource "azurerm_cdn_frontdoor_rule_set" "this" {
  name                     = replace("rs-${local.hostname_slug}", "-", "")
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
}

resource "azurerm_cdn_frontdoor_route" "this" {
  name                          = "r-${local.hostname_slug}"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.this.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.this.id]
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.this.id]
  enabled                       = true

  forwarding_protocol    = "HttpOnly"
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]
  https_redirect_enabled = true

  #cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.contoso.id, azurerm_cdn_frontdoor_custom_domain.fabrikam.id]
  link_to_default_domain          = true
}
