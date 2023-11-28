##############################################################################
#
# Author: Logan Mancuso
# Created: 11.27.2023
#
##############################################################################

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
    host_path      = "${abspath(path.module)}/app/config"
    container_path = "/vault/config"
    read_only      = true
  }
  volumes {
    host_path      = "${abspath(path.module)}/app/certs"
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
  depends_on = [local_file.root_ca, local_file.intranet_cert, local_file.client_priv, null_resource.generate_crt_files]
}
