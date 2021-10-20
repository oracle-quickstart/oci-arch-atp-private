## Copyright (c) 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_virtual_network" "VCN" {
  cidr_block     = var.VCN-CIDR
  dns_label      = "VCN"
  compartment_id = var.compartment_ocid
  display_name   = "VCN"
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_dhcp_options" "DhcpOptions1" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.VCN.id
  display_name   = "DHCPOptions1"

  // required
  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  // optional
  options {
    type                = "SearchDomain"
    search_domain_names = ["example.com"]
  }
}

resource "oci_core_nat_gateway" "NATGateway" {
  compartment_id = var.compartment_ocid
  display_name   = "NATGateway"
  vcn_id         = oci_core_virtual_network.VCN.id
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_internet_gateway" "InternetGateway" {
  compartment_id = var.compartment_ocid
  display_name   = "InternetGateway"
  vcn_id         = oci_core_virtual_network.VCN.id
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_route_table" "RouteTableViaIGW" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.VCN.id
  display_name   = "RouteTableViaIGW"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.InternetGateway.id
  }
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_route_table" "RouteTableViaNAT" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.VCN.id
  display_name   = "RouteTableViaNAT"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.NATGateway.id
  }
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_subnet" "WebSubnet" {
  cidr_block      = var.Webserver_PublicSubnet-CIDR
  display_name    = "WebSubnet"
  dns_label       = "fkN1"
  compartment_id  = var.compartment_ocid
  vcn_id          = oci_core_virtual_network.VCN.id
  route_table_id  = oci_core_route_table.RouteTableViaIGW.id
  dhcp_options_id = oci_core_dhcp_options.DhcpOptions1.id
  defined_tags    = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_subnet" "ATPEndpointSubnet" {
  cidr_block                 = var.ATP_PrivateSubnet-CIDR
  display_name               = "ATPEndpointSubnet"
  dns_label                  = "fkN2"
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_virtual_network.VCN.id
  route_table_id             = oci_core_route_table.RouteTableViaNAT.id
  dhcp_options_id            = oci_core_dhcp_options.DhcpOptions1.id
  prohibit_public_ip_on_vnic = true
  defined_tags               = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
