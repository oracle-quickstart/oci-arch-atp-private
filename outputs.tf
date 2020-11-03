output "ssh_private_key" {
  value = var.ssh_private_key != "" ? var.ssh_private_key : tls_private_key.public_private_key_pair.private_key_pem
}
