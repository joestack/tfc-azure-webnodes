output "server_ip" {
  value = azurerm_network_interface.main.*.private_ip_address
}

output "public_ip" {
  value = azurerm_public_ip.example.*.ip_address
}

