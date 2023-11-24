#
# .bash_profile (load on login)
#

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# User specific environment and startup programs

export PATH=$HOME/bin:$PATH:/usr/local/sbin

export PAGER="less -R"
export PERLDOC_PAGER="less -R"
export EDITOR='vim'
export GREP_OPTIONS='--color=auto'

# wanip
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'

# END
