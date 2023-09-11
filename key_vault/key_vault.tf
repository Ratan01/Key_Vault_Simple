provider "azurerm" {
    features {
      
    }
}
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "keyrk-resources"
  location = "West Europe"
}

resource "azurerm_key_vault" "kav" {
  name                = "rkkeyvault"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
}

resource "azurerm_key_vault_access_policy" "kvap" {
  key_vault_id = azurerm_key_vault.kav.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
  ]
}

data "azuread_service_principal" "sp" {
  display_name = "rk-app"
}

resource "azurerm_key_vault_access_policy" "rk-principal" {
  key_vault_id = azurerm_key_vault.kav.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.sp.object_id

  key_permissions = [
    "Get", "List", "Encrypt", "Decrypt"
  ]
}