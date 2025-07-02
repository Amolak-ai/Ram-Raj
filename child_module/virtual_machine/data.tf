data "azurerm_subnet" "subnet" {
name                 = var.subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
}

data "azurerm_public_ip" "pip" {
  name                = var.pip_name
  resource_group_name = var.rg_name
}

data "azurerm_key_vault" "kv" {
  name                = "bhim-kv007"
  resource_group_name = "dream-rg"
}
data "azurerm_key_vault_secret" "username" {
  name         = "vmusername"
  key_vault_id = data.azurerm_key_vault.kv.id
}
data "azurerm_key_vault_secret" "password" {
  name         = "vmpassword"
  key_vault_id = data.azurerm_key_vault.kv.id
}



