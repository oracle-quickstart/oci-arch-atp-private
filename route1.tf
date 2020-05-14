resource "oci_core_route_table" "RouteTableViaIGW" {
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_virtual_network.VCN.id
    display_name = "RouteTableViaIGW"
    route_rules {
        destination = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_internet_gateway.InternetGateway.id
    }
}
