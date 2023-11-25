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
ISUCON_HOME=$(
    cd $(dirname $0)
    cd ..
    pwd
)
[ -z "$ISUCON_HOSTS" ] && ISUCON_HOSTS="isu1 isu2 isu3"
[ -z "$TARGET_SERVER" ] && TARGET_SERVER="isu1"
[ -z "$ISUCON_SERVICE" ] && ISUCON_SERVICE="isupipe-go.service"
RSYNC_OPTION="-avzc --no-perms --no-owner --no-group --delete"
[ "$OPT_DRY_RUN" == 1 ] && RSYNC_OPTION="-avzc --no-perms --no-owner --no-group --delete -n"

# /etc/{path} => ../etc/{server_name}/{path}
to_local_path() {
    local REMOTE_PATH=$1
    local REMOTE_HOST=$2

    local LOCAL_PATH=${REMOTE_PATH/\/etc\//..\/etc\/$REMOTE_HOST\/}

    echo $LOCAL_PATH

    return 0
}

main() {
    # MySQL or MariaDB
    for server in ${ISUCON_HOSTS[@]}; do
        [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
        # TODO (都度設定する)
        # MySQL
        REMOTE_PATH=/etc/mysql/mysql.conf.d/mysqld.cnf
        LOCAL_PATH=$(to_local_path $REMOTE_PATH $server)
        rsync $RSYNC_OPTION $LOCAL_PATH root@$server:$REMOTE_PATH

        # MariaDB
        # REMOTE_PATH=/etc/mysql/mariadb.conf.d/50-server.cnf
        # LOCAL_PATH=$(to_local_path $REMOTE_PATH $server)
        # rsync $RSYNC_OPTION $LOCAL_PATH root@$server:$REMOTE_PATH
    done

    # nginx
    for server in ${ISUCON_HOSTS[@]}; do
        [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
        # TODO (都度設定する)
        REMOTE_PATH=/etc/nginx/nginx.conf
        LOCAL_PATH=$(to_local_path $REMOTE_PATH $server)
        rsync $RSYNC_OPTION $LOCAL_PATH root@$server:$REMOTE_PATH

        # TODO (都度設定する)
        REMOTE_PATH=/etc/nginx/sites-enabled/isupipe.conf
        LOCAL_PATH=$(to_local_path $REMOTE_PATH $server)
        rsync $RSYNC_OPTION $LOCAL_PATH root@$server:$REMOTE_PATH
    done

    # redis
    # for server in ${ISUCON_HOSTS[@]}; do
    #     [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
    #     REMOTE_PATH=/etc/redis/redis.conf
    #     LOCAL_PATH=$(to_local_path $REMOTE_PATH $server)
    #     rsync $RSYNC_OPTION $LOCAL_PATH root@$server:$REMOTE_PATH
    # done

    # pdns
    for server in ${ISUCON_HOSTS[@]}; do
        [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
        REMOTE_PATH=/etc/powerdns/pdns.conf
        LOCAL_PATH=$(to_local_path $REMOTE_PATH $server)
        rsync $RSYNC_OPTION $LOCAL_PATH root@$server:$REMOTE_PATH
    done

    # systemd
    for server in ${ISUCON_HOSTS[@]}; do
        [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
        REMOTE_PATH=/etc/systemd/system/$ISUCON_SERVICE
        LOCAL_PATH=$(to_local_path $REMOTE_PATH $server)
        rsync $RSYNC_OPTION $LOCAL_PATH root@$server:$REMOTE_PATH
    done

    # app
    for server in ${ISUCON_HOSTS[@]}; do
        [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
        # TODO (都度設定する)
        # rsync $RSYNC_OPTION $ISUCON_HOME/webapp/docker-compose-go.yml $server:/home/isucon/webapp/docker-compose-go.yml

        # TODO (都度設定する)
        rsync $RSYNC_OPTION $ISUCON_HOME/webapp/go/ $server:/home/isucon/webapp/go/

        # TODO (都度設定する)
        rsync $RSYNC_OPTION $ISUCON_HOME/webapp/sql/ $server:/home/isucon/webapp/sql/
    done

    # alp
    for server in ${ISUCON_HOSTS[@]}; do
        [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
        # TODO (都度設定する)
        rsync $RSYNC_OPTION $ISUCON_HOME/alp.yml $server:/home/isucon/alp.yml
    done
}

main

# END
