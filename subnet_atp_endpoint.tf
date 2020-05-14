resource "oci_core_subnet" "ATPEndpointSubnet" {
  cidr_block = var.ATP_PrivateSubnet-CIDR
  display_name = "ATPEndpointSubnet"
  dns_label = "fkN2"
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_virtual_network.VCN.id
  route_table_id = oci_core_route_table.RouteTableViaNAT.id
  dhcp_options_id = oci_core_dhcp_options.DhcpOptions1.id
}


