data "digitalocean_ssh_key" "ssh_key" {
  count = length(var.ssh_keys)
  name  = element(var.ssh_keys, count.index)
}


resource "digitalocean_droplet" "application_droplet" {
  name               = var.project_name
  size               = var.droplet_size
  image              = var.droplet_image
  region             = var.digitalocean_region
  monitoring         = true
  private_networking = true
  ssh_keys           = data.digitalocean_ssh_key.ssh_key[*].id
}

resource "digitalocean_project" "current" {
  name        = var.project_name
  description = "Fax Machine"
  purpose     = "For Good"
  # Choices: Development, Staging, Production
  environment = "Development"
  resources = concat([
    # domains have urns
    digitalocean_domain.application_domain.urn,
    # droplets have urns
    digitalocean_droplet.application_droplet.urn,

    # lbs have urns (soon)
    digitalocean_loadbalancer.application_public_lb.urn,
    ]
  )
}
