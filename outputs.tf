output "generated_ssh_private_key" {
  value = tls_private_key.public_private_key_pair.private_key_pem
}

output "webserver1_public_ip" {
  value = [data.oci_core_vnic.Webserver1_VNIC1.public_ip_address]
}