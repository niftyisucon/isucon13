#!/bin/bash

help() {
    cat <<HELP
 Usage: $0 [options...] <arg>

 Options
    -h              show this help
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
RSYNC_OPTION="-avzc --delete"
[ "$OPT_DRY_RUN" == 1 ] && RSYNC_OPTION="-avzc -n --delete"

main() {
    for server in ${ISUCON_HOSTS[@]}; do
        [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
        # ssh -t $server "sudo cat /var/log/mysql/slow.log | pt-query-digest --limit 100% --since '\`date '+%F %T' -d '-5 minutes\`' --utc' > /tmp/pt_result.txt"
        ssh -t $server "sudo cat /var/log/mysql/slow.log | pt-query-digest --limit 100% > /tmp/pt_result.txt"
        rsync $RSYNC_OPTION $server:/tmp/pt_result.txt ./

        # TODO: add issue comment
    done
}

main

# END
