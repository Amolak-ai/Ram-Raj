module "resource_group" {
  source      = "../child_module/resource_group"
  rg_name     = "dream-rg"
  rg_location = "centralindia"
}
module "public_ip_frontend" {
  depends_on        = [module.resource_group]
  source            = "../child_module/public_ip"
  pip_name          = "amol-f-pip"
  rg_name           = "dream-rg"
  rg_location       = "centralindia"
  allocation_method = "Static"
}
module "public_ip_backend" {
  depends_on        = [module.resource_group]
  source            = "../child_module/public_ip"
  pip_name          = "amol-b-pip"
  rg_name           = "dream-rg"
  rg_location       = "centralindia"
  allocation_method = "Static"
}
module "vnet" {
  depends_on    = [module.resource_group]
  source        = "../child_module/vnet"
  vnet_name     = "amol-vnet"
  address_space = ["10.0.0.0/16"]
  rg_name       = "dream-rg"
  rg_location   = "centralindia"
}
module "subnet_frontend" {
  depends_on       = [module.vnet]
  source           = "../child_module/subnet"
  rg_name          = "dream-rg"
  vnet_name        = "amol-vnet"
  subnet_name      = "amol-f-subnet"
  address_prefixes = ["10.0.1.0/24"]
}
module "subnet_backend" {
  depends_on       = [module.vnet]
  source           = "../child_module/subnet"
  rg_name          = "dream-rg"
  vnet_name        = "amol-vnet"
  subnet_name      = "amol-b-subnet"
  address_prefixes = ["10.0.2.0/24"]
}
module "virtual_machine_frontend" {
  depends_on  = [module.subnet_frontend, module.public_ip_frontend, module.key_vault,module.secret]
  source      = "../child_module/virtual_machine"
  nic_name    = "amol-f-nic"
  rg_location = "centralindia"
  rg_name     = "dream-rg"
  vm_name     = "amol-f-vm"
  vm_size     = "Standard_B1s"
  subnet_name = "amol-f-subnet"
  pip_name    = "amol-f-pip"
  vnet_name   = "amol-vnet"
  os_disk_name = "frontend-osdisk"
}
module "virtual_machine_backend" {
  depends_on  = [module.subnet_backend, module.public_ip_backend, module.key_vault,module.secret]
  source      = "../child_module/virtual_machine"
  nic_name    = "amol-b-nic"
  rg_location = "centralindia"
  rg_name     = "dream-rg"
  vm_name     = "amol-b-vm"
  vm_size     = "Standard_B1s"
  subnet_name = "amol-b-subnet"
  pip_name    = "amol-b-pip"
  vnet_name   = "amol-vnet"
  os_disk_name = "backend-osdisk"
}
module "key_vault" {
  depends_on  = [module.resource_group, ]
  source      = "../child_module/key_vault"
  kv_name     = "bhim-kv007"
  rg_location = "centralindia"
  rg_name     = "dream-rg"
}
module "secret" {
  depends_on    = [module.key_vault]
  source        = "../child_module/secret"
  username_name = "vmusername"
  username      = "devopsadmin"
  password_name = "vmpassword"
  password      = "Roggers@4321"

}
module "sqlserver" {
    depends_on = [ module.resource_group,module.secret]
    source = "../child_module/sql_server"
    sqlserver_name = "amolsqlserver"
    rg_name = "dream-rg"
    rg_location = "centralindia" 
}
module "sql_database"{
    depends_on = [ module.sqlserver ]
    source = "../child_module/sql_database"
    sqldb_name = "amak-db"
    sqlserver_name = "amolsqlserver"
    rg_name = "dream-rg"
}