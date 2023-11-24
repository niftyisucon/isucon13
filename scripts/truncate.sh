#!/bin/bash

set -e

help() {
    cat <<HELP
 Usage: $0 [options...] <host>

 Options
    -h  show this help
HELP
    exit 0
}

while getopts "h" OPT; do
    case $OPT in
        h) help ;;
        *) exit ;;
    esac
done

shift $((OPTIND - 1))

TARGET_SERVER=$1
[ -z "$ISUCON_HOSTS" ] && ISUCON_HOSTS="isu1 isu2 isu3"
[ -z "$TARGET_SERVER" ] && TARGET_SERVER="isu1"

main() {
    # nginx
    for server in ${ISUCON_HOSTS[@]}; do
        [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
        echo "truncate access log ($server)"
        ssh -t $server "sudo truncate -s 0 /var/log/nginx/access_ltsv.log"
    done

    # mysqld
    for server in ${ISUCON_HOSTS[@]}; do
        [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
        echo "truncate slow query log ($server)"
        ssh -t $server "sudo truncate -s 0 /var/log/mysql/slow.log"
    done
}

main

# END
