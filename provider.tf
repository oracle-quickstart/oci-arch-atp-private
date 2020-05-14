provider "oci" {
  version          = ">= 3.64.0" 
  tenancy_ocid     = var.tenancy_ocid
  region           = var.region
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