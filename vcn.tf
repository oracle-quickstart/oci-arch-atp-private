resource "oci_core_virtual_network" "VCN" {
  cidr_block = var.VCN-CIDR
  dns_label = "VCN"
  compartment_id = var.compartment_ocid
  display_name = "VCN"
}
