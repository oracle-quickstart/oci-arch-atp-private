## Copyright (c) 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

# Gets the Id of a specific OS Images
data "oci_core_images" "OSImageLocal" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = var.OsImage
}

resource "oci_core_instance" "Webserver1" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")
  compartment_id      = var.compartment_ocid
  display_name        = "WebServer1"
  shape               = var.Shape
  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.OSImageLocal.images[0], "id")
  }
  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
  }
  create_vnic_details {
    subnet_id = oci_core_subnet.WebSubnet.id
    nsg_ids   = [oci_core_network_security_group.WebSecurityGroup.id, oci_core_network_security_group.SSHSecurityGroup.id]
  }
}

data "oci_core_vnic_attachments" "Webserver1_VNIC1_attach" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")
  compartment_id = var.compartment_ocid
  instance_id         = oci_core_instance.Webserver1.id
}

data "oci_core_vnic" "Webserver1_VNIC1" {
  vnic_id = data.oci_core_vnic_attachments.Webserver1_VNIC1_attach.vnic_attachments.0.vnic_id
}

