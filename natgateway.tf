## Copyright (c) 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_nat_gateway" "NATGateway" {
    compartment_id = var.compartment_ocid
    display_name = "NATGateway"
    vcn_id = oci_core_virtual_network.VCN.id
}
