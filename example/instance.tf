module "front_hub" {
  source  = "./../"

  resource_group_name = "front-hub-solution_example-testing"
  resource_group_location = "West US"
  domains = [
    "pashmak.guru"
  ]
}

output "name_servers" {
  value = module.front_hub.name_servers
}