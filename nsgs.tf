## Copyright (c) 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_network_security_group" "WebSecurityGroup" {
  compartment_id = var.compartment_ocid
  display_name   = "WebSecurityGroup"
  vcn_id         = oci_core_virtual_network.VCN.id
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_network_security_group" "SSHSecurityGroup" {
  compartment_id = var.compartment_ocid
  display_name   = "SSHSecurityGroup"
  vcn_id         = oci_core_virtual_network.VCN.id
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_network_security_group" "ATPSecurityGroup" {
  compartment_id = var.compartment_ocid
  display_name   = "ATPSecurityGroup"
  vcn_id         = oci_core_virtual_network.VCN.id
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

# Rules related to ATPSecurityGroup

# EGRESS

resource "oci_core_network_security_group_security_rule" "ATPSecurityEgressGroupRule" {
  network_security_group_id = oci_core_network_security_group.ATPSecurityGroup.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = var.VCN-CIDR
  destination_type          = "CIDR_BLOCK"
}

# INGRESS

resource "oci_core_network_security_group_security_rule" "ATPSecurityIngressGroupRules" {
  network_security_group_id = oci_core_network_security_group.ATPSecurityGroup.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = var.VCN-CIDR
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = 1522
      min = 1522
    }
  }
}

# Rules related to WebSecurityGroup

# EGRESS

resource "oci_core_network_security_group_security_rule" "WebSecurityEgressATPGroupRule" {
  network_security_group_id = oci_core_network_security_group.WebSecurityGroup.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = oci_core_network_security_group.ATPSecurityGroup.id
  destination_type          = "NETWORK_SECURITY_GROUP"
}

resource "oci_core_network_security_group_security_rule" "WebSecurityEgressInternetGroupRule" {
  network_security_group_id = oci_core_network_security_group.WebSecurityGroup.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}

# INGRESS

resource "oci_core_network_security_group_security_rule" "WebSecurityIngressGroupRules" {
  network_security_group_id = oci_core_network_security_group.WebSecurityGroup.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

# Rules related to SSHSecurityGroup

# EGRESS

resource "oci_core_network_security_group_security_rule" "SSHSecurityEgressGroupRule" {
  network_security_group_id = oci_core_network_security_group.SSHSecurityGroup.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}

# INGRESS

resource "oci_core_network_security_group_security_rule" "SSHSecurityIngressGroupRules" {
  network_security_group_id = oci_core_network_security_group.SSHSecurityGroup.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = 22
      min = 22
    }
  }
}

