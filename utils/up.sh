#!/bin/bash
unset http_proxy
unset https_proxy

BACKEND="$1"
if [ -z "$BACKEND" ]; then
    echo "missing backend"
    exit
fi
PORT=$(cat etc/${BACKEND}.port)

for URL in $(cat etc/haproxy.urls);
do
   echo "try http://localhost:${PORT}${URL}"
   wget --timeout=600 --retry-connrefused --wait=30 -nv -O /dev/null http://localhost:${PORT}${URL}
done

