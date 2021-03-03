## Copyright (c) 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_internet_gateway" "InternetGateway" {
    compartment_id = var.compartment_ocid
    display_name = "InternetGateway"
    vcn_id = oci_core_virtual_network.VCN.id
    defined_tags   = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
