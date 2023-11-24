#
# .bashrc (load on execute sh)
#

# インタラクティブモードじゃなければ何もしない
case $- in
    *i*) ;;
    *) return ;;
esac

# 入力が最後のヒストリと一致する場合に記録しない
HISTCONTROL=ignoreboth

# ヒストリーを上書きしないで追記する
shopt -s histappend

# ヒストリーのサイズを設定する
HISTSIZE=1000
HISTFILESIZE=2000

# コマンドの実行後に毎回ウィンドウの大きさをチェックし、
# 必要に応じて LINES と COLUMNS の値を更新します。
shopt -s checkwinsize

# lessを非テキストの入力に対応
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# カラープロンプトをオンにする
case "$TERM" in
    xterm-color | *-256color) color_prompt=yes ;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Prompt extention
if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
    source /usr/share/git-core/contrib/completion/git-prompt.sh
elif [ -f "$HOME/.git-prompt.sh" ]; then
    source "$HOME/.git-prompt.sh"
elif [ -f "/usr/lib/git-core/git-sh-prompt" ]; then
    source "/usr/lib/git-core/git-sh-prompt"
fi

if [ -f "$HOME/.svn-prompt.sh" ]; then
    source "$HOME/.svn-prompt.sh"
fi

GIT_PS1_SHOWDIRTYSTATE=true

if [ "$color_prompt" = yes ]; then
    if type __git_ps1 >/dev/null 2>&1; then
        if type __svn_ps1 >/dev/null 2>&1; then
            PS1='\[\033[;38;05;76m\]\u@\h\[\033[00m\]:\[\033[01;38;05;75m\]\w\[\033[1;31m\]$(__git_ps1 " (%s)")\[\033[00m\]\[\033[1;31m\]$(__svn_ps1)\[\033[00m\]\$ '
        else
            PS1='\[\033[;38;05;76m\]\u@\h\[\033[00m\]:\[\033[01;38;05;75m\]\w\[\033[1;31m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '
        fi
    else
        PS1='\[\033[;38;05;76m\]\u@\h\[\033[00m\]:\[\033[01;38;05;75m\]\w\[\033[1;31m\]\[\033[00m\]\$ '
    fi
else
    if type __git_ps1 >/dev/null 2>&1; then
        PS1='\u@\h:\w$(__git_ps1 " (%s)")\$ '
    else
        PS1='\u@\h:\w\$ '
    fi
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm* | rxvt*)
        PS1="\[\e]0;\u@\h: \w\a\]$PS1"
        ;;
    *) ;;

esac

# ls をカラーモードに便利なエイリアス追加
case "$OSTYPE" in
    darwin*)
        if [ -f /usr/local/bin/gdircolors ] && [ -f /usr/local/bin/gls ]; then
            test -r ~/.dircolors && eval "$(gdircolors -b ~/.dircolors)" || eval "$(gdircolors -b)"
            alias ls='gls --color=auto --time-style=long-iso'
            alias dir='gls --color=auto --format=vertical'
            alias vdir='gls --color=auto --format=long'
        fi
        ;;
    linux*)
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto --time-style=long-iso'
        alias dir='ls --color=auto --format=vertical'
        alias vdir='ls --color=auto --format=long'
        ;;
esac

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# for bash completion
BASH_CMP_FILES=(
    bash_completion
    git
    git-completion.bash
    rails
    svn-completion.bash
    tuned.bash
    yum-utils.bash
    yum.bash
)

BASH_CMP_DIRS=(
    /usr/local/etc
    /usr/local/etc/bash_completion.d
    /etc
    /etc/bash_completion.d
)

for BASH_CMP_FILE in "${BASH_CMP_FILES[@]}"; do
    for BASH_CMP_DIR in "${BASH_CMP_DIRS[@]}"; do
        if [ -d "$BASH_CMP_DIR" ] && [ -f "$BASH_CMP_DIR/$BASH_CMP_FILE" ]; then
            source "$BASH_CMP_DIR/$BASH_CMP_FILE"
            break
        fi
    done
done

# END
