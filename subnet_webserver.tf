resource "oci_core_subnet" "WebSubnet" {
  cidr_block = var.Webserver_PublicSubnet-CIDR
  display_name = "WebSubnet"
  dns_label = "fkN1"
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_virtual_network.VCN.id
  route_table_id = oci_core_route_table.RouteTableViaIGW.id
  dhcp_options_id = oci_core_dhcp_options.DhcpOptions1.id
}


