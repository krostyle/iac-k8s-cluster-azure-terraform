#Resource Group
resource "azurerm_resource_group" "aks-demo" {
  name     = var.rg_name
  location = var.rg_location
  tags = {
    "example" = var.rg_group
  }
}

#Public IP
resource "azurerm_public_ip" "pip-aks-demo" {
  name                = var.pip_name
  resource_group_name = azurerm_resource_group.aks-demo.name
  location            = azurerm_resource_group.aks-demo.location
  allocation_method   = var.pip_allocation_method
  tags = {
    "example" = var.rg_group
  }
}

#Virtual Network
resource "azurerm_virtual_network" "vnet-aks-demo" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.aks-demo.location
  resource_group_name = azurerm_resource_group.aks-demo.name
}

#Subnet
resource "azurerm_subnet" "subnet-aks-demo" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.aks-demo.name
  virtual_network_name = azurerm_virtual_network.vnet-aks-demo.name
  address_prefixes     = var.subnet_address_prefixes
}

#Container Registry
resource "azurerm_container_registry" "acr-aks-demo" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.aks-demo.name
  location            = azurerm_resource_group.aks-demo.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
}

#Kubernetes Cluster
resource "azurerm_kubernetes_cluster" "k8s-cluser-aks-demo" {
  name                              = var.k8s_name
  location                          = azurerm_resource_group.aks-demo.location
  resource_group_name               = azurerm_resource_group.aks-demo.name
  dns_prefix                        = var.dns_prefix
  kubernetes_version                = var.k8s_version
  role_based_access_control_enabled = var.rbac_enabled
  default_node_pool {
    name                = var.np_name
    node_count          = var.np_node_count
    vm_size             = var.np_vm_size
    vnet_subnet_id      = azurerm_subnet.subnet-aks-demo.id
    enable_auto_scaling = var.np_enable_auto_scaling
    min_count           = var.np_min_count
    max_count           = var.np_max_count
  }
  #add node pool additional
  node_pool {
    name                = "nodepool2"
    node_count          = 1
    vm_size             = "Standard_D2_v2"
    vnet_subnet_id      = azurerm_subnet.subnet-aks-demo.id
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
    max_pods            = 80
  }
  service_principal {
    client_id     = var.sp_client_id
    client_secret = var.sp_client_secret
  }
  network_profile {
    network_plugin = var.netp_network_plugin
    network_policy = var.netp_network_policy
  }

  tags = {
    "example" = var.rg_group
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "extra-node" {
  name                  = "adicional"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s-cluser-aks-demo.id
  vm_size               = "Standard_D2_v2"
  node_count            = 1
  max_pods              = 80
}

