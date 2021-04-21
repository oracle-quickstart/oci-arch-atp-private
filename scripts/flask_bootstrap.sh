#!/bin/bash

echo '== 1. Install Oracle instant client'
if [[ $(uname -r | sed 's/^.*\(el[0-9]\+\).*$/\1/') == "el8" ]]
then 
   dnf install -y oracle-instantclient-release-el8
   dnf install -y oracle-instantclient-basic
else
  yum install -y oracle-instantclient-release-el7
  yum install -y oracle-instantclient-basic
fi 

echo '== 2. Install Python3, and then with pip3 cx_Oracle and flask'
yum install -y python36
pip3 install cx_Oracle
pip3 install flask

echo '== 3. Disabling firewall and starting HTTPD service'
service firewalld stop
service firewalld disable

echo '== 4. Unzip TDE wallet zip file'
unzip -o /tmp/${ATP_tde_wallet_zip_file} -d /usr/lib/oracle/${oracle_instant_client_version_short}/client64/lib/network/admin/

echo '== 5. Move sqlnet.ora to /usr/lib/oracle/${oracle_instant_client_version_short}/client64/lib/network/admin/'
cp /tmp/sqlnet.ora /usr/lib/oracle/${oracle_instant_client_version_short}/client64/lib/network/admin/

echo '== 6. Run Flask with ATP access'
python3 --version
chmod +x /tmp/flask_ATP.sh
nohup /tmp/flask_ATP.sh > /tmp/flask_ATP.log &
sleep 5
ps -ef | grep flask