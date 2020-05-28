## Copyright (c) 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_network_security_group" "WebSecurityGroup" {
    compartment_id = var.compartment_ocid
    display_name = "WebSecurityGroup"
    vcn_id = oci_core_virtual_network.VCN.id
}

resource "oci_core_network_security_group" "SSHSecurityGroup" {
    compartment_id = var.compartment_ocid
    display_name = "SSHSecurityGroup"
    vcn_id = oci_core_virtual_network.VCN.id
}

resource "oci_core_network_security_group" "ATPSecurityGroup" {
    compartment_id = var.compartment_ocid
    display_name = "ATPSecurityGroup"
    vcn_id = oci_core_virtual_network.VCN.id
}