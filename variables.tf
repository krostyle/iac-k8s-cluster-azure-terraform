#Tags
variable "rg_group" {}

#Resource Group
variable "rg_name" {}
variable "rg_location" {}


#Public IP
variable "pip_name" {}
variable "pip_allocation_method" {}

#Virtual Network
variable "vnet_name" {}
variable "vnet_address_space" {}

#Subnet
variable "subnet_name" {}
variable "subnet_address_prefixes" {}

#Container Registry
variable "acr_name" {}
variable "acr_sku" {}
variable "acr_admin_enabled" {}

#Kubernetes Cluster
#Main
variable "k8s_name" {}
variable "k8s_version" {}
variable "dns_prefix" {}
variable "rbac_enabled" {}
#Node Pool
variable "np_name" {}
variable "np_node_count" {}
variable "np_vm_size" {}
variable "np_enable_auto_scaling" {}
variable "np_min_count" {}
variable "np_max_count" {}
#Service Principal
variable "sp_client_id" {}
variable "sp_client_secret" {}
#Network Profile
variable "netp_network_plugin" {}
variable "netp_network_policy" {}




