#!/bin/bash
server=${3:-$(uname -n)}

case $server in
#        dsawplone03)
#                backend="plone010$2"
#                if [ $# -eq "2" ]; then
#                        ssh dsawplone04 $(realpath $0) $1 $2 dsawplone03
#                        ssh dsawplone05 $(realpath $0) $1 $2 dsawplone03
#                fi
#        ;;
#        dsawplone04)
#                backend="plone020$2"
#                if [ $# -eq "2" ]; then
#                        ssh dsawplone03 $(realpath $0) $1 $2 dsawplone04
#                        ssh dsawplone05 $(realpath $0) $1 $2 dsawplone04
#                fi
#        ;;
#        dsawplone05)
#                backend="plone030$2"
#                if [ $# -eq "2" ]; then
#                        ssh dsawplone03 $(realpath $0) $1 $2 dsawplone05
#                        ssh dsawplone04 $(realpath $0) $1 $2 dsawplone05
#                fi
#        ;;
        air.creepingserver.it)
                backend="plone010$2"
        ;;
        *)
                echo "invalid server $(uname -n)"
                popd
                exit 1
esac

case $1 in
        start)
                echo "enable server zope/$backend" | socat stdio $(dirname $0)/../var/haproxy.sock
                echo "$backend enabled on $(uname -n)"
        ;;
        stop)
                echo "disable server zope/$backend" | socat stdio $(dirname $0)/../var/haproxy.sock
                echo "$backend disabled on $(uname -n)"
        ;;
        *)
                echo "invalid command"
                popd
                exit 1
esac
