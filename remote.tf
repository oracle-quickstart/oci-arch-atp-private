## Copyright (c) 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

data "template_file" "flask_ATP_py_template" {
  template = file("./scripts/flask_ATP.py")

  vars = {
    ATP_password                        = var.ATP_password
    ATP_alias                           = join("", [var.ATP_database_db_name, "_medium"])
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "template_file" "flask_ATP_sh_template" {
  template = file("./scripts/flask_ATP.sh")

  vars = {
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "template_file" "flask_bootstrap_template" {
  template = file("./scripts/flask_bootstrap.sh")

  vars = {
    ATP_tde_wallet_zip_file             = var.ATP_tde_wallet_zip_file
    oracle_instant_client_version       = var.oracle_instant_client_version
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "template_file" "sqlnet_ora_template" {
  template = file("./scripts/sqlnet.ora")

  vars = {
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

resource "null_resource" "Webserver1_ConfigMgmt" {
  depends_on = [oci_core_instance.Webserver1, module.oci-adb.adb_database]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.Webserver1_VNIC1.public_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.sqlnet_ora_template.rendered
    destination = "/tmp/sqlnet.ora"
  }

  provisioner "local-exec" {
    command = "echo '${module.oci-adb.adb_database.adb_wallet_content}' >> ${var.ATP_tde_wallet_zip_file}_encoded"
  }

  provisioner "local-exec" {
    command = "base64 --decode ${var.ATP_tde_wallet_zip_file}_encoded > ${var.ATP_tde_wallet_zip_file}"
  }

  provisioner "local-exec" {
    command = "rm -rf ${var.ATP_tde_wallet_zip_file}_encoded"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.Webserver1_VNIC1.public_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = var.ATP_tde_wallet_zip_file
    destination = "/tmp/${var.ATP_tde_wallet_zip_file}"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.Webserver1_VNIC1.public_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.flask_ATP_py_template.rendered
    destination = "/tmp/flask_ATP.py"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.Webserver1_VNIC1.public_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.flask_ATP_sh_template.rendered
    destination = "/tmp/flask_ATP.sh"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.Webserver1_VNIC1.public_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.flask_bootstrap_template.rendered
    destination = "/tmp/flask_bootstrap.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.Webserver1_VNIC1.public_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = [
      "chmod +x /tmp/flask_bootstrap.sh",
    "sudo /tmp/flask_bootstrap.sh"]
  }

}


