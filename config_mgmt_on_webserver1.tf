## Copyright (c) 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "null_resource" "Webserver1_ConfigMgmt" {
  depends_on = [oci_core_instance.Webserver1, oci_database_autonomous_database.ATPdatabase]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.Webserver1_VNIC1.public_ip_address
      private_key = var.ssh_private_key != "" ? var.ssh_private_key : tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = ["echo '== 1. Install Oracle instant client'",
      "sudo -u root yum -y install oracle-release-el7",
      "sudo -u root yum-config-manager --enable ol7_oracle_instantclient",
      "sudo -u root yum -y install oracle-instantclient18.3-basic",

      "echo '== 2. Install Python3, and then with pip3 cx_Oracle and flask'",
      "sudo -u root yum install -y python36",
      "sudo -u root pip3 install cx_Oracle",
      "sudo -u root pip3 install flask",

      "echo '== 3. Disabling firewall and starting HTTPD service'",
    "sudo -u root service firewalld stop"]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.Webserver1_VNIC1.public_ip_address
      private_key = var.ssh_private_key != "" ? var.ssh_private_key : tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "sqlnet.ora"
    destination = "/tmp/sqlnet.ora"
  }

  provisioner "local-exec" {
    command = "echo '${data.oci_database_autonomous_database_wallet.ATP_database_wallet.content}' >> ${var.ATP_tde_wallet_zip_file}_encoded"
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
      private_key = var.ssh_private_key != "" ? var.ssh_private_key : tls_private_key.public_private_key_pair.private_key_pem
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
      private_key = var.ssh_private_key != "" ? var.ssh_private_key : tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "flask_ATP.py"
    destination = "/tmp/flask_ATP.py"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.Webserver1_VNIC1.public_ip_address
      private_key = var.ssh_private_key != "" ? var.ssh_private_key : tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "flask_ATP.sh"
    destination = "/tmp/flask_ATP.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.Webserver1_VNIC1.public_ip_address
      private_key = var.ssh_private_key != "" ? var.ssh_private_key : tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = ["echo '== 4. Unzip TDE wallet zip file'",
      "sudo -u root unzip -o /tmp/${var.ATP_tde_wallet_zip_file} -d /usr/lib/oracle/18.3/client64/lib/network/admin/",
      "echo '== 5. Move sqlnet.ora to /usr/lib/oracle/18.3/client64/lib/network/admin/'",
      "sudo -u root cp /tmp/sqlnet.ora /usr/lib/oracle/18.3/client64/lib/network/admin/"]
  }

}

resource "null_resource" "Webserver1_Flask_WebServer_and_access_ATP" {
  depends_on = [null_resource.Webserver1_ConfigMgmt]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.Webserver1_VNIC1.public_ip_address
      private_key = var.ssh_private_key != "" ? var.ssh_private_key : tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = ["echo '== 6. Run Flask with ATP access'",
      "sudo -u root python3 --version",
      "sudo -u root chmod +x /tmp/flask_ATP.sh",
      "sudo -u root sed -i 's/ATP_password/${var.ATP_password}/g' /tmp/flask_ATP.py",
      "sudo -u root sed -i 's/ATP_alias/${var.ATP_database_db_name}_medium/g' /tmp/flask_ATP.py",
      "sudo -u root nohup /tmp/flask_ATP.sh > /tmp/flask_ATP.log &",
      "sleep 5",
    "sudo -u root ps -ef | grep flask"]
  }

}
