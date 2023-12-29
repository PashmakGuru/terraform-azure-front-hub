module "front_hub" {
  source  = "./../"

  resource_group_name = "front-hub-solution_example-testing"
  resource_group_location = "West US"

  zones = [
    "pashmak.guru"
  ]
  origin_groups = [
    "argocd-admin-pashmak-guru"
  ]
  public_ip_origins = {
    "argocd-admin-pashmak-guru-kubernetes-cluster" = {
        origin_group_name = "argocd-admin-pashmak-guru"
        pip_resource_group_name = "module-azure-administrative-kubernetes-cluster-nodes"
        pip_name_prefix = "kubernetes-"
        origin_host_header = "argocd-admin.pashmak.guru"
    }
  }
  endpoints = [
    "argocd-admin-pashmak-guru"
  ]
  rule_sets = [
    "argocdadminpashmakguru"
  ]
  routes = {
    "argocd-admin-pashmak-guru" = {
        endpoint_name = "argocd-admin-pashmak-guru",
        origin_group_name = "argocd-admin-pashmak-guru",
        origin_names = [
            "argocd-admin-pashmak-guru-kubernetes-cluster"
        ],
        rule_set_names = [
            "argocdadminpashmakguru"
        ],
        patterns_to_match = [
            "/*"
        ],
        use_azure_domain = true
    }
  }
}

output "name_servers" {
  value = module.front_hub.name_servers
}

output "urls" {
  value = module.front_hub.urls
}
