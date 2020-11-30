## Copyright (c) 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

provider "oci" {
  version          = ">= 3.64.0" 
  tenancy_ocid     = var.tenancy_ocid
  region           = var.region
  fingerprint      = var.fingerprint
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
}

provider "null" {
  version = "= 2.1.2"
}

provider "local" {
  version = "= 1.2.2"
}

provider "random" {
  version = "= 2.1.2"
}
