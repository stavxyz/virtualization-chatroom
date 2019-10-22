resource "digitalocean_domain" "application_domain" {
  name = var.application_domain
}

resource "digitalocean_certificate" "cert" {
  name    = replace(title(replace(local.application_domain_slug, "_", " ")), " ", "")
  type    = "lets_encrypt"
  domains = [var.application_domain]
  lifecycle {
    create_before_destroy = true
  }
}

# This points the 'chat.' subdomain to our application load balancer.
resource "digitalocean_record" "application_lb_chat" {
  domain = var.application_domain
  type   = "A"
  ttl    = 60
  name   = "chat"
  value  = digitalocean_loadbalancer.application_public_lb.ip
}

# This points our application domain straight to the load balancer.
resource "digitalocean_record" "application_lb_root" {
  domain = var.application_domain
  type   = "A"
  ttl    = 60
  name   = "@"
  value  = digitalocean_loadbalancer.application_public_lb.ip
}

resource "digitalocean_loadbalancer" "application_public_lb" {
  name                   = format("%s-%s", replace(local.application_domain_slug, "_", "-"), "lb-public")
  region                 = var.digitalocean_region
  redirect_http_to_https = true

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 1119
    target_protocol = "http"

    certificate_id = digitalocean_certificate.cert.id
  }

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 1119
    target_protocol = "http"

    certificate_id = digitalocean_certificate.cert.id
  }

  forwarding_rule {
    entry_port     = 1119
    entry_protocol = "tcp"

    target_port     = 1119
    target_protocol = "tcp"

  }

  forwarding_rule {
    entry_port     = 22
    entry_protocol = "tcp"

    target_port     = 22
    target_protocol = "tcp"

    certificate_id = digitalocean_certificate.cert.id
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  # Switch to this once the app is running /hello
  #
  # healthcheck {
  #   port     = 8081
  #   protocol = "http"
  #   path     = "/hello"
  # }

  droplet_ids = [digitalocean_droplet.application_droplet.id]
}
