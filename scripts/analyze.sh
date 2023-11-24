#!/bin/bash

set -x

OPT_SLOW_QUERY=0

help() {
    cat <<HELP
 Usage: $0 [options...] <host>

 Options
    -h  show this help
    -n  dry-run
HELP
    exit 0
}

while getopts "hs" OPT; do
    case $OPT in
        s) OPT_SLOW_QUERY="1" ;;
        h) help ;;
        *) exit ;;
    esac
done

shift $((OPTIND - 1))

TARGET_SERVER=$1

./analyze_access_log.sh $TARGET_SERVER 2>&1

if [ "$OPT_SLOW_QUERY" == 1 ]; then
    ./analyze_slow_log.sh $TARGET_SERVER 2>&1
fi

# END
