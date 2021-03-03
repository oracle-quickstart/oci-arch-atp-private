## Copyright (c) 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_subnet" "WebSubnet" {
  cidr_block = var.Webserver_PublicSubnet-CIDR
  display_name = "WebSubnet"
  dns_label = "fkN1"
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_virtual_network.VCN.id
  route_table_id = oci_core_route_table.RouteTableViaIGW.id
  dhcp_options_id = oci_core_dhcp_options.DhcpOptions1.id
  defined_tags   = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}


