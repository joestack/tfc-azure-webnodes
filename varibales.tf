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

variable "public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvOp4xxCMWtSfMkO73Xv29aavZlPKFdJ3kI9CpY1Dnl0Q945TybNcFQuZ53RRvw7ccOx0CctuzDRwW3FX9rdD96htu2uoZXeeY0tB2gb3md/LpKw3I+PRJXIHwwbfpQK8rxXlmDIiPR8P7frNs/Y3z2dYxlmlE+OB4Y3hbF10vBxJUECX2AmTNDb+IBS1APJc/Sw+04aEwh2kiv5tfqhM+1bjhKxBzY/h5+H7jV0psH/TeAkr7yvY7KVwrqad+MXGvMfAwp0ziWh7BWMUeOHsCIJx9tUlLPL/5HvjeFniALXVIIrGo/kz1SI0Q5Na60iAETi1t8jlWOOPOWLe28JUL joern@Think-X1"
}