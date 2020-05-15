provider "oci" {
  version          = ">= 3.64.0" 
  tenancy_ocid     = var.tenancy_ocid
  fingerprint      = var.fingerprint
  user_ocid        = var.user_ocid
  region           = var.region
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