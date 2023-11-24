#!/bin/bash

help() {
    cat <<HELP
 Usage: $0 [options...] <arg>

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
RSYNC_OPTION="-avzc --delete"
[ "$OPT_DRY_RUN" == 1 ] && RSYNC_OPTION="-avzc -n --delete"

main() {
    for server in ${ISUCON_HOSTS[@]}; do
        [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
        rsync $RSYNC_OPTION ../alp.yml $server:/home/isucon/alp.yml
        ssh -t $server "sudo cat /var/log/nginx/access_ltsv.log | alp ltsv --config /home/isucon/alp.yml > /tmp/alp_result.txt"
        rsync $RSYNC_OPTION $server:/tmp/alp_result.txt ./

        # TODO: create issue
    done
}

main

# END
