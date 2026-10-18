resource "azurerm_monitor_data_collection_rule" "syslog" {
  name                = "dcr-olu-operations"
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Linux"
  tags                = local.tags

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.main.id
      name                  = "operations-workspace"
    }
  }

  data_sources {
    syslog {
      name           = "lab-syslog"
      facility_names = ["local0"]
      log_levels     = ["Info", "Notice", "Warning", "Error", "Critical", "Alert", "Emergency"]
      streams        = ["Microsoft-Syslog"]
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["operations-workspace"]
  }
}

resource "azurerm_monitor_data_collection_rule_association" "vm" {
  name                    = "operations-syslog"
  target_resource_id      = azurerm_linux_virtual_machine.main.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.syslog.id
}
