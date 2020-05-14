resource "oci_core_internet_gateway" "InternetGateway" {
    compartment_id = var.compartment_ocid
    display_name = "InternetGateway"
    vcn_id = oci_core_virtual_network.VCN.id
}
