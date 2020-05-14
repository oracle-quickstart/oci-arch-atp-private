resource "oci_core_nat_gateway" "NATGateway" {
    compartment_id = var.compartment_ocid
    display_name = "NATGateway"
    vcn_id = oci_core_virtual_network.VCN.id
}
