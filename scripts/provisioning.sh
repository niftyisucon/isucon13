#!/bin/bash

set -e

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
RSYNC_OPTION="-avzc --delete"
[ "$OPT_DRY_RUN" == 1 ] && RSYNC_OPTION="-avzc -n --delete"

ALP_VERSION=v1.0.21

main() {
    # provisioning
    for server in ${ISUCON_HOSTS[@]}; do
        [ ! -z "$TARGET_SERVER" ] && [ $server != "$TARGET_SERVER" ] && continue
        # alp
        ssh -t $server "rm -f alp_linux_amd64.tar.gz"
        ssh -t $server "wget https://github.com/tkuchiki/alp/releases/download/$ALP_VERSION/alp_linux_amd64.tar.gz"
        ssh -t $server "tar xzvf alp_linux_amd64.tar.gz"
        ssh -t $server "rm -f alp_linux_amd64.tar.gz"
        ssh -t $server "sudo mv alp /usr/local/bin/"

        # apt update
        ssh -t $server "sudo apt update"

        # pt-query-digest
        ssh -t $server "sudo apt install percona-toolkit"

        # utils
        ssh -t $server "sudo apt install build-essential"
        ssh -t $server "sudo apt install dstat"
        ssh -t $server "sudo apt install htop"
        ssh -t $server "sudo apt install silversearcher-ag"
        ssh -t $server "sudo apt install tree"

        # go
        ssh -t $server "rm -f go1.21.4.linux-amd64.tar.gz"
        ssh -t $server "wget https://go.dev/dl/go1.21.4.linux-amd64.tar.gz"
        ssh -t $server "sudo tar -C /usr/local -xzf go1.21.4.linux-amd64.tar.gz"
        ssh -t $server "rm -f go1.21.4.linux-amd64.tar.gz"
        ssh -t $server "sudo ln -s -f /usr/local/go/bin/go /usr/local/bin/go"
        ssh -t $server "sudo ln -s -f /usr/local/go/bin/gofmt /usr/local/bin/gofmt"

        # change nginx log permission
        ssh -t $server "sudo chmod 644 /var/log/nginx/access.log"
        ssh -t $server "sudo touch /var/log/nginx/access_ltsv.log && sudo chown www-data:adm /var/log/nginx/access_ltsv.log && sudo chmod 644 /var/log/nginx/access_ltsv.log"
        ssh -t $server "sudo chmod 644 /var/log/nginx/error.log"

        # change mysql slow log permission
        ssh -t $server "sudo touch /var/log/mysql/slow.log && sudo chown mysql:adm /var/log/mysql/slow.log && sudo chmod 644 /var/log/mysql/slow.log"

        # setup ssh (authorized_keys, id_ed25519, id_ed25519.pub) for isucon user
        rsync $RSYNC_OPTION $ISUCON_HOME/.ssh/id_ed25519 $server:/home/isucon/.ssh/id_ed25519
        rsync $RSYNC_OPTION $ISUCON_HOME/.ssh/id_ed25519.pub $server:/home/isucon/.ssh/id_ed25519.pub
        rsync $RSYNC_OPTION $ISUCON_HOME/.ssh/authorized_keys $server:/home/isucon/.ssh/authorized_keys.add
        ssh -t $server "cp -p /home/isucon/.ssh/authorized_keys /home/isucon/.ssh/authorized_keys.org && cat /home/isucon/.ssh/id_ed25519.pub /home/isucon/.ssh/authorized_keys.* | sort | uniq > /home/isucon/.ssh/authorized_keys"
        ssh -t $server "rm -f /home/isucon/.ssh/authorized_keys.add"

        # setup ssh (authorized_keys, id_ed25519, id_ed25519.pub) for root user
        rsync $RSYNC_OPTION $ISUCON_HOME/.ssh/authorized_keys $server:/tmp/authorized_keys.add
        rsync $RSYNC_OPTION $ISUCON_HOME/.ssh/id_ed25519.pub $server:/tmp/id_ed25519.pub
        ssh -t $server "sudo cp /root/.ssh/authorized_keys /tmp/authorized_keys.org && sudo chmod 666 /tmp/authorized_keys.org"
        ssh -t $server "cat /tmp/id_ed25519.pub /tmp/authorized_keys.org /tmp/authorized_keys.add | sort | uniq > /tmp/authorized_keys.new"
        ssh -t $server "sudo cp /tmp/authorized_keys.new /root/.ssh/authorized_keys"
        ssh -t $server "sudo rm -f /tmp/authorized_keys.org"
        ssh -t $server "sudo rm -f /tmp/authorized_keys.add"
        ssh -t $server "sudo rm -f /tmp/id_ed25519.pub"

        # vim
        rsync $RSYNC_OPTION $ISUCON_HOME/dotfiles/.vimrc $server:/home/isucon/.vimrc
        ssh -t $server "mkdir -p /home/isucon/.vim"
        ssh -t $server "mkdir -p /home/isucon/.vim/backup"
        ssh -t $server "mkdir -p /home/isucon/.vim/swap"
        ssh -t $server "mkdir -p /home/isucon/.vim/skel"
        rsync $RSYNC_OPTION $ISUCON_HOME/dotfiles/.vim/skel/skel.sh $server:/home/isucon/.vim/skel/skel.sh
        ssh -t $server "curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        ssh -t $server "vim -c 'set shortmess=at' +PlugInstall! +qall"

        # dotfiles
        rsync $RSYNC_OPTION $ISUCON_HOME/dotfiles/.bash_profile $server:/home/isucon/.bash_profile
        rsync $RSYNC_OPTION $ISUCON_HOME/dotfiles/.bashrc $server:/home/isucon/.bashrc
        rsync $RSYNC_OPTION $ISUCON_HOME/dotfiles/.dircolors $server:/home/isucon/.dircolors
        rsync $RSYNC_OPTION $ISUCON_HOME/dotfiles/.git-prompt.sh $server:/home/isucon/.git-prompt.sh
        rsync $RSYNC_OPTION $ISUCON_HOME/dotfiles/.gitconfig $server:/home/isucon/.gitconfig
        rsync $RSYNC_OPTION $ISUCON_HOME/dotfiles/.gitignore_global $server:/home/isucon/.gitignore_global
    done
}

main

# END
