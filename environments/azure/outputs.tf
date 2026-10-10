output "resource_group_name" {
  description = "Azure Resource Group name"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "Azure VNet ID"
  value       = azurerm_virtual_network.main.id
}

output "subnet_id" {
  description = "Azure subnet ID"
  value       = azurerm_subnet.public.id
}

output "network_security_group_id" {
  description = "Azure NSG ID"
  value       = azurerm_network_security_group.web.id
}

output "vm_id" {
  description = "Azure VM ID"
  value       = azurerm_linux_virtual_machine.web.id
}

output "public_ip" {
  description = "Azure VM public IP"
  value       = azurerm_public_ip.vm.ip_address
}
