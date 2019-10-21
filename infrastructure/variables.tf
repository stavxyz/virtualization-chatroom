variable "digitalocean_region" {
  type    = string
  default = "sfo2"
}

variable "droplet_size" {
  type        = string
  default     = "2gb"
  description = "Defaults to 2gb (2gb ram, 2 vcpu, 40gb ssd). See `doctl compute size list` for more."
}

variable "droplet_image" {
  type    = string
  default = "ubuntu-18-04-x64"
}

variable "application_domain" {
  type    = string
  default = "bueno.network"
}

variable "project_name" {
  type    = string
  default = "ee4376"
}

# Create ssh keys in advance and refer to them by name here.
# --> https://cloud.digitalocean.com/account/security
variable "ssh_keys" {
  type = list(string)
  default = [
    "docloud_edu"
  ]
}


locals {
  application_domain_slug = replace(var.application_domain, ".", "_dot_")
}
