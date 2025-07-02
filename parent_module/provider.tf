terraform {
  required_version = ">= 1.3.0, < 2.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.33.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "350e4500-bc54-46c6-9b0a-7ca946c56838"
}