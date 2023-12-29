variable "domains" {
  type = list(string)
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
  default = "West US"
}

# variable "records_or_kubernetes_clusters" {
#   type = map(object({
#     name = string
#   }))
# }
