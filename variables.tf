## Copyright (c) 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "region" {}
variable "fingerprint" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "availablity_domain_name" {}
variable "ATP_password" {}

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.0"
}

variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "ATP_PrivateSubnet-CIDR" {
  default = "10.0.2.0/24"
}

variable "Webserver_PublicSubnet-CIDR" {
  default = "10.0.1.0/24"
}

variable "VCNname" {
  default = "VCN"
}

variable "Shape" {
  default = "VM.Standard.E2.1"
}

variable "ATP_database_cpu_core_count" {
  default = 1
}

variable "ATP_database_data_storage_size_in_tbs" {
  default = 1
}

variable "ATP_database_db_name" {
  default = "myatpdb"
}

variable "ATP_database_db_version" {
  default = "19c"
}

variable "ATP_database_defined_tags_value" {
  default = ""
}

variable "ATP_database_display_name" {
  default = "ATP"
}

variable "ATP_database_freeform_tags" {
  default = {
    "Owner" = "ATP"
  }
}

variable "ATP_database_license_model" {
  default = "LICENSE_INCLUDED"
}

variable "ATP_tde_wallet_zip_file" {
  default = "tde_wallet_ATPdb1.zip"
}

variable "ATP_private_endpoint_label" {
  default = "ATPPrivateEndpoint"
}

variable "instance_os" {
  description = "Operating system for compute instances"
  default     = "Oracle Linux"
}

variable "linux_os_version" {
  description = "Operating system version for all Linux instances"
  default     = "7.9"
}
