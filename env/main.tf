##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

#######################################
# Provider
#######################################

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">=3.0.2"
    }
  }
  backend "http" {
    address  = "https://gitlab.com/api/v4/projects/52530007/terraform/state/hashicorp-vault"
    username = "loganmancuso"
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}