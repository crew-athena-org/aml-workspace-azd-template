data "azurerm_client_config" "current" {}

locals {
  suffixs = var.environment != "" ? [var.deployment_name, var.environment] : [var.deployment_name]
  tags = {
    deployedBy : "IAC"
    deploymentName : var.deployment_name
  }
}

module "naming" {
  source        = "Azure/naming/azurerm"
  suffix        = local.suffixs
  unique-length = 3
}


resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = module.naming.resource_group.name
}

resource "azurerm_application_insights" "appi" {
  name                = module.naming.resource_group.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"

  tags = local.tags
}

resource "azurerm_key_vault" "akv" {
  name                = module.naming.key_vault.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"

  tags = local.tags
}

resource "azurerm_storage_account" "stacc" {
  name                     = module.naming.storage_account.name
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.tags
}

resource "azurerm_container_registry" "acr" {
  name                = module.naming.container_registry.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  admin_enabled       = true

  tags = local.tags
}

resource "azurerm_machine_learning_workspace" "adl_mlw" {
  name                          = module.naming.machine_learning_workspace.name
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  application_insights_id       = azurerm_application_insights.appi.id
  key_vault_id                  = azurerm_key_vault.akv.id
  storage_account_id            = azurerm_storage_account.stacc.id
  container_registry_id         = azurerm_container_registry.acr.id
  public_network_access_enabled = true

  tags = local.tags

  identity {
    type = "SystemAssigned"
  }
}
