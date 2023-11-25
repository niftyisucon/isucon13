#!/bin/bash

help() {
    cat <<HELP
 Usage: $0 [options...] <arg>

 Options
    -h  show this help
    -n  dry-run
HELP
    exit 0
}

while getopts "nh" OPT; do
    case $OPT in
        n) OPT_DRY_RUN=1 ;;
        h) help ;;
        *) exit ;;
    esac
done

shift $((OPTIND - 1))

TARGET_SERVER=$1
ISUCON_HOME=$(
    cd $(dirname $0)
    cd ..
    pwd
)
[ -z "$ISUCON_HOSTS" ] && ISUCON_HOSTS="isu1 isu2 isu3"
[ -z "$TARGET_SERVER" ] && TARGET_SERVER="isu1"
[ -z "$ISUCON_SERVICE" ] && ISUCON_SERVICE="isupipe-go.service"
RSYNC_OPTION="-avzc --no-perms --no-owner --no-group --omit-dir-times --delete"
[ "$OPT_DRY_RUN" == 1 ] && RSYNC_OPTION="-avzc --no-perms --no-owner --no-group --omit-dir-times --delete -n"

main() {
    # rsync $RSYNC_OPTION isu1:~/webapp/ $ISUCON_HOME/webapp/
    for server in ${ISUCON_HOSTS[@]}; do
        [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
        # TODO (都度設定する)
        # rsync $RSYNC_OPTION root@$server:/etc/nginx/ $ISUCON_HOME/etc/$server/nginx/
        # rsync $RSYNC_OPTION root@$server:/etc/mysql/ $ISUCON_HOME/etc/$server/mysql/
        # rsync $RSYNC_OPTION root@$server:/etc/systemd/ $ISUCON_HOME/etc/$server/systemd/
        # rsync $RSYNC_OPTION root@$server:/etc/redis/ $ISUCON_HOME/etc/$server/redis/
        # rsync $RSYNC_OPTION root@$server:/etc/powerdns/ $ISUCON_HOME/etc/$server/powerdns/

        # opt
        rsync $RSYNC_OPTION root@$server:/opt/init_zone_once.sh $ISUCON_HOME/opt/$server/init_zone_once.sh
    done
}

main

# END
