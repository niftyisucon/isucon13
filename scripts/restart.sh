#!/bin/bash

help() {
    cat <<HELP
 Usage: $0 [options...] <host>

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
[ -z "$ISUCON_HOSTS" ] && ISUCON_HOSTS="isu1 isu2 isu3"
[ -z "$TARGET_SERVER" ] && TARGET_SERVER="isu1"
[ -z "$ISUCON_SERVICE" ] && ISUCON_SERVICE="isupipe-go.service"
RSYNC_OPTION="-avzc --delete"
[ "$OPT_DRY_RUN" == 1 ] && RSYNC_OPTION="-avzc -n --delete"

main() {
    # MySQL or MariaDB
    for server in ${ISUCON_HOSTS[@]}; do
        [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
        # TODO (都度設定する)
        # MySQL
        ssh -t $server "sudo systemctl stop mysql.service"
        ssh -t $server "sudo systemctl start mysql.service"

        # MariaDB
        # ssh -t $server "sudo systemctl stop mariadb.service"
        # ssh -t $server "sudo systemctl start mariadb.service"
    done

    # nginx
    for server in ${ISUCON_HOSTS[@]}; do
        [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
        ssh -t $server "sudo systemctl stop nginx.service"
        ssh -t $server "sudo systemctl start nginx.service"
    done

    # redis
    # for server in ${ISUCON_HOSTS[@]}; do
    #     [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
    #     ssh -t $server "sudo systemctl stop redis.service"
    #     ssh -t $server "sudo systemctl start redis.service"
    # done

    # pdns
    for server in ${ISUCON_HOSTS[@]}; do
        [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
        ssh -t $server "sudo systemctl stop pdns.service"
        ssh -t $server "sudo systemctl start pdns.service"
    done

    # cd $ISUCON_HOME/webapp/go
    # GOOS=linux GOARCH=amd64 go build -o isuports_linux

    # app
    for server in ${ISUCON_HOSTS[@]}; do
        [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
        ssh -t $server "sudo systemctl enable $ISUCON_SERVICE"
        ssh -t $server "sudo systemctl stop $ISUCON_SERVICE"
        ssh -t $server "sudo systemctl daemon-reload"
        ssh -t $server "sudo systemctl start $ISUCON_SERVICE"
    done
}

main

# END
