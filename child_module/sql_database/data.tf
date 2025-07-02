data "azurerm_mssql_server" "sqlserver" {
  name                = var.sqlserver_name
  resource_group_name = var.rg_name
}

