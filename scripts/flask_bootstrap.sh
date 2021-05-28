#!/bin/bash

#echo '== 1. Install Oracle instant client'
#if [[ $(uname -r | sed 's/^.*\(el[0-9]\+\).*$/\1/') == "el8" ]]
#then 
#   dnf install -y oracle-instantclient-release-el8
#   dnf install -y oracle-instantclient-basic
#else
#  yum install -y oracle-instantclient-release-el7
#  yum install -y oracle-instantclient-basic
#fi 

# Install Oracle instant client

echo '== 1. Install Oracle instant client & Python3 stuff'
if [[ $(uname -r | sed 's/^.*\(el[0-9]\+\).*$/\1/') == "el8" ]]
then 
  if [[ $(uname -m) == "aarch64" ]]
  then
    echo '=== 2.1 aarch64 platform & OL8' 
  	yum install -y https://yum.oracle.com/repo/OracleLinux/OL8/oracle/instantclient/aarch64/getPackage/oracle-instantclient${oracle_instant_client_version_short}-basic-${oracle_instant_client_version_short}.0.0.0-1.aarch64.rpm
  	yum install -y https://yum.oracle.com/repo/OracleLinux/OL8/oracle/instantclient/aarch64/getPackage/oracle-instantclient${oracle_instant_client_version_short}-sqlplus-${oracle_instant_client_version_short}.0.0.0-1.aarch64.rpm
    yum install -y python36
    yum install -y python3-devel
    pip3 install --upgrade setuptools
  else
  	echo '=== 2.1 x86_64 platform & OL8'
    dnf install -y https://yum.oracle.com/repo/OracleLinux/OL8/oracle/instantclient/x86_64/getPackage/oracle-instantclient${oracle_instant_client_version_short}-basic-${oracle_instant_client_version_short}.0.0.0-1.x86_64.rpm
    dnf install -y https://yum.oracle.com/repo/OracleLinux/OL8/oracle/instantclient/x86_64/getPackage/oracle-instantclient${oracle_instant_client_version_short}-sqlplus-${oracle_instant_client_version_short}.0.0.0-1.x86_64.rpm
    yum install -y python36
  fi	
else
  if [[ $(uname -m) == "aarch64" ]]
  then 	
  	echo '=== 2.1 aarch64 platform & OL7' 
  	yum install -y https://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/aarch64/getPackage/oracle-instantclient${oracle_instant_client_version_short}-basic-${oracle_instant_client_version_short}.0.0.0-1.aarch64.rpm
    yum install -y https://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/aarch64/getPackage/oracle-instantclient${oracle_instant_client_version_short}-sqlplus-${oracle_instant_client_version_short}.0.0.0-1.aarch64.rpm
    yum install -y python36
    yum install -y python3-devel
    pip3 install --upgrade setuptools
  else
    echo '=== 2.1 x86_64 platform & OL7'
    yum install -y https://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/x86_64/getPackage/oracle-instantclient${oracle_instant_client_version_short}-basic-${oracle_instant_client_version_short}.0.0.0-1.x86_64.rpm
    yum install -y https://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/x86_64/getPackage/oracle-instantclient${oracle_instant_client_version_short}-sqlplus-${oracle_instant_client_version_short}.0.0.0-1.x86_64.rpm
    yum install -y python36
  fi
fi 

echo '== 2. Install pip3 install for cx_Oracle and flask'
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