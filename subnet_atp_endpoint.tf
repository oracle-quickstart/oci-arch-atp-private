## Copyright (c) 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_subnet" "ATPEndpointSubnet" {
  cidr_block = var.ATP_PrivateSubnet-CIDR
  display_name = "ATPEndpointSubnet"
  dns_label = "fkN2"
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_virtual_network.VCN.id
  route_table_id = oci_core_route_table.RouteTableViaNAT.id
  dhcp_options_id = oci_core_dhcp_options.DhcpOptions1.id
  prohibit_public_ip_on_vnic = true
}


