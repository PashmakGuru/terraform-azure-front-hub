# Fronthub Terraform Module

[![Terraform CI](https://github.com/PashmakGuru/terraform-azure-front-hub/actions/workflows/terraform-ci.yaml/badge.svg)](https://github.com/PashmakGuru/terraform-azure-front-hub/actions/workflows/terraform-ci.yaml)

## Overview
This Terraform configuration automates the setup of Azure CDN resources, streamlining the deployment and management of CDN infrastructure.

### Terraform Architecture
```mermaid
%%tfmermaid
%%{init:{"theme":"default","themeVariables":{"lineColor":"#6f7682","textColor":"#6f7682"}}}%%
flowchart LR
classDef r fill:#5c4ee5,stroke:#444,color:#fff
classDef v fill:#eeedfc,stroke:#eeedfc,color:#5c4ee5
classDef ms fill:none,stroke:#dce0e6,stroke-width:2px
classDef vs fill:none,stroke:#dce0e6,stroke-width:4px,stroke-dasharray:10
classDef ps fill:none,stroke:none
classDef cs fill:#f7f8fa,stroke:#dce0e6,stroke-width:2px
subgraph "n0"["CDN"]
n1["azurerm_cdn_frontdoor_endpoint.<br/>this"]:::r
n2["azurerm_cdn_frontdoor_origin.<br/>this"]:::r
n3["azurerm_cdn_frontdoor_origin_group.<br/>this"]:::r
n4["azurerm_cdn_frontdoor_profile.<br/>this"]:::r
n5["azurerm_cdn_frontdoor_route.<br/>this"]:::r
n6["azurerm_cdn_frontdoor_rule_set.<br/>this"]:::r
end
class n0 cs
subgraph "n7"["DNS"]
n8["azurerm_dns_zone.this"]:::r
end
class n7 cs
subgraph "n9"["Base"]
na["azurerm_resource_group.this"]:::r
end
class n9 cs
subgraph "nb"["Network"]
nc{{"data.azurerm_public_ips.this"}}:::r
end
class nb cs
subgraph "nd"["Input Variables"]
ne(["var.endpoints"]):::v
nf(["var.origin_groups"]):::v
ng(["var.public_ip_origins"]):::v
nh(["var.resource_group_location"]):::v
ni(["var.resource_group_name"]):::v
nj(["var.routes"]):::v
nk(["var.rule_sets"]):::v
nl(["var.zones"]):::v
end
class nd vs
subgraph "nm"["Output Values"]
nn(["output.name_servers"]):::v
no(["output.urls"]):::v
end
class nm vs
n4-->n1
ne--->n1
n3-->n2
nc-->n2
n4-->n3
nf--->n3
na-->n4
n1-->n5
n2-->n5
n6-->n5
nj--->n5
n4-->n6
nk--->n6
na-->n8
nl--->n8
nh--->na
ni--->na
ng--->nc
n8--->nn
n1--->no
```

## Features
- **Resource Group Management**: Creates and manages Azure resource groups.
- **DNS Zone Configuration**: Handles the setup and configuration of Azure DNS zones.
- **CDN Frontdoor Profiles**: Sets up Azure CDN frontdoor profiles for content delivery optimization.
- **Dynamic Origin Groups**: Supports dynamic creation of origin groups based on input variables.
- **Public IP Integration**: Configures public IPs for CDN origins.
- **CDN Endpoints**: Manages the creation and configuration of CDN endpoints.
- **Routing Rules**: Implements routing rules for efficient content delivery.
- **Automatic Output Generation**: Outputs important details like name servers and endpoint URLs.

## File Structure
- [01-providers.tf](./01-providers.tf): Defines Terraform and AzureRM provider requirements.
- [outputs.tf](./outputs.tf): Contains outputs like name servers and URLs for CDN endpoints.
- [variables.tf](./variables.tf): Specifies required variables for the configuration.

## Usage
For usage examples, refer to the [`example`](./example) directory.

## Workflows
| Name | Description |
|---|---|
| [terraform-ci.yaml](.github/workflows/terraform-ci.yaml) | A workflow for linting and auto-formatting Terraform code. Triggered by pushes to  `main` and `dev` branches or on pull requests, it consists of two jobs: `tflint` for lint checks, `format` for code formatting and submit a PR, and `tfmermaid` to update architecture graph and submit a PR. |
