module "front_hub" {
  source  = "./../"

  resource_group_name = "front-hub-solution_example-testing"
  resource_group_location = "West US"
  domains = [
    "pashmak.guru"
  ]
#   records_or_kubernetes_clusters = {
#     "pashmak.guru" = {
#         argocd = {
#             subscription = "266f5455-27b5-4975-bfc3-cebfbe3e3b46"
#             resource_group = "module-azure-administrative-kubernetes-cluster-nodes"
#             loadbalancer = "kubernetes"
#             pip_name_prefix = "kubernetes-"
#         }
#     }
#   }
}

output "name_servers" {
  value = module.front_hub.name_servers
}

output "urls" {
  value = module.front_hub.urls
}
