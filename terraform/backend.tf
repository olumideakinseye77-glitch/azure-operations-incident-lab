terraform {
  backend "azurerm" {
    resource_group_name  = "rg-olu-terraform-state"
    storage_account_name = "stoluentnete74816"
    container_name       = "tfstate"
    key                  = "operations-incident-lab.tfstate"

    use_cli          = true
    use_azuread_auth = true
  }
}
