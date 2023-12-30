variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type    = string
  default = "West US"
}

#   [
#     "pashmak.guru"
#   ]
variable "zones" {
  type = list(string)
}

#   [
#     "argocd-admin-pashmak-guru"
#   ]
variable "origin_groups" {
  type = list(string)
}

#   {
#     "argocd-admin-pashmak-guru_cluster-booo" => {
#           "origin_group_name" => "..."
#           "pip_resource_group_name" => "..."
#           "pip_name_prefix" => "..."
#           "origin_host_header" => "argocd.admin.pashmak.guru"
#      }
#   }
variable "public_ip_origins" {
  type = map(object({
    origin_group_name       = string
    pip_resource_group_name = string
    pip_name_prefix         = string
    origin_host_header      = string
  }))
}

# [
#     "argocd-admin-pashmak-guru"
# ]
variable "endpoints" {
  type = list(string)
}

# [
#     "argocdadminpashmakguru"
# ]
variable "rule_sets" {
  type = list(string)
}

# {
#     "argocd-admin-pashmak-guru" => {
#         "endpoint_name" => "argocd-admin-pashmak-guru",
#         "origin_group_name" => "argocd-admin-pashmak-guru",
#         "origin_names" => [
#             "argocd-admin-pashmak-guru_cluster-booo"
#         ],
#         "rule_set_names" => [
#             "argocdadminpashmakguru"
#         ],
#         "patterns_to_match" => [
#             "/*"
#         ]
#     }
# }
variable "routes" {
  type = map(object({
    endpoint_name     = string
    origin_group_name = string
    origin_names      = list(string)
    rule_set_names    = list(string)
    patterns_to_match = list(string)
    use_azure_domain  = bool
  }))
}
