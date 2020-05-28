## Copyright (c) 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_route_table" "RouteTableViaNAT" {
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_virtual_network.VCN.id
    display_name = "RouteTableViaNAT"
    route_rules {
        destination = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_nat_gateway.NATGateway.id
    }
}

