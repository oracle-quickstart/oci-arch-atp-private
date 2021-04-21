## Copyright (c) 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

from flask import Flask, render_template, url_for, request
import os
import socket
import cx_Oracle

app = Flask(__name__)

@app.route('/')
def oracleatpcheck():
     os.environ['TNS_ADMIN'] = '/usr/lib/oracle/${oracle_instant_client_version_short}/client64/lib/network/admin'
     connection = cx_Oracle.connect('admin', '${ATP_password}', '${ATP_alias}')
     cursor = connection.cursor()
     rs = cursor.execute("select name from v$database")
     dbname = rs.fetchone()
     cursor.close()
     connection.close()
          
     return 'I am connected to ATP Database via private endpoint! ATP dbname taken from v$database view is {}'.format(dbname[0])

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80, debug=True)