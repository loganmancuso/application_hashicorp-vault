##############################################################################
#
# Author: Logan Mancuso
# Created: 11.27.2023
#
##############################################################################

##  CA Certs ##

output "cert_root" {
  description = "root certificate authority"
  value       = tls_self_signed_cert.root.cert_pem
}

output "root_pub_key" {
  description = "root certificate authority public key"
  value       = tls_private_key.root.public_key_pem
}

output "client_priv_key" {
  description = "client certificate private key"
  value       = tls_private_key.client.private_key_pem
  sensitive   = true
}

output "client_pub_key" {
  description = "client certificate public key"
  value       = tls_private_key.client.public_key_pem
}

output "cert_intranet" {
  description = "client certificate"
  value       = tls_locally_signed_cert.intranet.cert_pem
}