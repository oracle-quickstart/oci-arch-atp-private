## Copyright (c) 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_dhcp_options" "DhcpOptions1" {
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_virtual_network.VCN.id
  display_name = "DHCPOptions1"

  // required
  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  // optional
  options {
    type = "SearchDomain"
    search_domain_names = [ "example.com" ]
  }
}
