#/bin/bash

rm -f /data/mongod.lock
/usr/bin/mongod -f /etc/mongod.conf
