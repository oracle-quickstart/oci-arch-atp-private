## Copyright (c) 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "oci-adb" {
  source                                = "github.com/oracle-quickstart/oci-adb"
  adb_password                          = var.ATP_password
  compartment_ocid                      = var.compartment_ocid
  adb_database_cpu_core_count           = var.ATP_database_cpu_core_count
  adb_database_data_storage_size_in_tbs = var.ATP_database_data_storage_size_in_tbs
  adb_database_db_name                  = var.ATP_database_db_name
  adb_database_db_version               = var.ATP_database_db_version
  adb_database_display_name             = var.ATP_database_display_name
  adb_database_freeform_tags            = var.ATP_database_freeform_tags
  adb_database_license_model            = var.ATP_database_license_model
  adb_database_db_workload              = "OLTP"
  adb_free_tier                         = var.ATP_free_tier
  use_existing_vcn                      = var.ATP_private_endpoint
  adb_private_endpoint                  = var.ATP_private_endpoint
  vcn_id                                = var.ATP_private_endpoint ? oci_core_virtual_network.VCN.id : null
  adb_nsg_id                            = var.ATP_private_endpoint ? oci_core_network_security_group.ATPSecurityGroup.id : null
  adb_private_endpoint_label            = var.ATP_private_endpoint ? var.ATP_private_endpoint_label : null
  adb_subnet_id                         = var.ATP_private_endpoint ? oci_core_subnet.ATPEndpointSubnet.id : null
  defined_tags                          = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
