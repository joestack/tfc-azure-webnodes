variable "prefix" {
  default = "webnode"
}

variable "network_address_space" {
  description = "CIDR for this deployment"
  default     = "192.168.0.0/16"
}

variable "web_node_count" {
  description = "number of worker nodes"
  default     = "3"
}

variable "admin_username" {
  description = "instance username"
}

variable "admin_password" {
  description = "instance password"
}
