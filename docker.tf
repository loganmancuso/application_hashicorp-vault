##############################################################################
#
# Author: Logan Mancuso
# Created: 11.27.2023
#
##############################################################################

locals {
  app_config_path = "${path.module}/app/config"
  app_certs_path  = "${path.module}/app/certs"
}

# Template Vault Config File #
data "template_file" "vault_config" {
  template = file("${path.module}/templates/main.hcl")
  vars = {
    tls_cert_file      = "${element(split("/", local_file.intranet_cert.filename), length(split("/", local_file.intranet_cert.filename)) - 1)}.crt"
    tls_key_file       = "${element(split("/", local_file.client_priv.filename), length(split("/", local_file.client_priv.filename)) - 1)}"
    tls_client_ca_file = "${element(split("/", local_file.root_ca.filename), length(split("/", local_file.root_ca.filename)) - 1)}.crt"
  }
}

resource "local_file" "vault_config_rendered" {
  content  = data.template_file.vault_config.rendered
  filename = "${local.app_config_path}/config.hcl"
}

# Create a network for the app
resource "docker_network" "vault_network" {
  name = "vault-network"
}

# Create a volume for the app data
resource "docker_volume" "vault_data" {
  name = "vault-data"
}

# Pull the vault image
resource "docker_image" "vault" {
  name = "hashicorp/vault:latest"
}

# Create the vault container
resource "docker_container" "webui" {
  name    = "vault"
  image   = docker_image.vault.image_id
  restart = "unless-stopped"
  env = [
    "TZ=America/New_York"
  ]
  volumes {
    volume_name    = docker_volume.vault_data.name
    container_path = "/mnt/vault-data"
    read_only      = false
  }
  volumes {
    host_path      = "${abspath(path.module)}/${local.app_config_path}"
    container_path = "/vault/config"
    read_only      = true
  }
  volumes {
    host_path      = "${abspath(path.module)}/${local.app_certs_path}"
    container_path = "/etc/ssl/certs"
    read_only      = true
  }
  networks_advanced {
    name = docker_network.vault_network.name
  }
  ports {
    internal = 8200
    external = 8200
  }
  ports {
    internal = 8201
    external = 8201
  }
  entrypoint = ["vault", "server", "-config", "/vault/config"]
  depends_on = [local_file.root_ca, local_file.intranet_cert, local_file.client_priv, null_resource.generate_crt_files, local_file.vault_config_rendered]
}
