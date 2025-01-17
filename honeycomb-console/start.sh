#!/bin/bash

set -e

if [ ! -d /home/admin/honeycomb ]; then
    # compatible; with old version honeycomb-server image
    rpm -i /root/honeycomb-server.rpm
fi

# patch server_ctl
if [ -f /tmp/server_ctl ]; then
    mv /tmp/server_ctl /home/admin/honeycomb/bin/server_ctl
fi

chown admin:admin -R /home/admin/honeycomb

# add honeycomb command
if [ ! -e /usr/bin/honeycomb ]; then
    ln -s /home/admin/honeycomb/target/honeycomb/bin/control /usr/bin/honeycomb
fi

echo "starting honeycomb server..."

su admin -c "/home/admin/honeycomb/bin/server_ctl start"
if ! ls /home/admin/honeycomb/run/appsRoot/honeycomb-console* > /dev/null 2>&1; then
    cd /home/admin/apps && control publish ./honeycomb-console_$HONEYCOMB_VERSION.tgz
fi

sleep inf
