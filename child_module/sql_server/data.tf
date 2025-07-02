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