resource "azurerm_mssql_server" "sqlserver" {
  name                         = var.sqlserver_name
  resource_group_name          = var.rg_name
  location                     = var.rg_location
  version                      = "12.0"
  administrator_login          = data.azurerm_key_vault_secret.username.value
  administrator_login_password = data.azurerm_key_vault_secret.password.value
}
