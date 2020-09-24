# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

## Aliases

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

## functions

# create a new directory and enters it
function mkd() {
	mkdir -p "$@" && cd "$_";
}

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features.
if ! shopt -oq posix; then
    if [ -r /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -r /etc/bash_completion ]; then
        . /etc/bash_completion
    elif [ -r /usr/local/etc/profile.d/bash_completion.sh ]; then
        . /usr/local/etc/profile.d/bash_completion.sh
    fi
fi

# source local bash-completion scripts
if [ -d "$HOME/.bash_completion.d" ]; then
    for f in $HOME/.bash_completion.d/*; do
        source $f
    done
fi

# setup Go vars
[ -z ${GOROOT+x} ] && { [ -d /usr/local/go ] && export GOROOT=/usr/local/go; }
[ -z ${GOROOT+x} ] || { [ -d $HOME/go ] && export GOPATH=$HOME/go; }

# setup exports
_paths=()
_paths+=($HOME/bin)
[ -z ${GOROOT+x} ] || _paths+=($GOROOT/bin)
[ -z ${GOPATH+x} ] || _paths+=($GOPATH/bin)
for p in "${_paths[@]}"; do
    [ -d $p ] && export PATH=$PATH:$p
done

# setup prompt
# To install powerline:
# $ go get -u -v github.com/justjanne/powerline-go
# $ git clone https://github.com/powerline/fonts.git --depth=1
# $ cd ./fonts && ./install.sh && cd .. && rm -rf ./fonts
function _update_ps1() {
    PS1="$($GOPATH/bin/powerline-go -error $?)"
}
if [ "$TERM" != "linux" ] && [ -f "$GOPATH/bin/powerline-go" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

## Setup ssh-agent
env=~/.ssh/agent.env
agent_load_env () {
    test -f "$env" && . "$env" >| /dev/null
}
agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null
}
agent_load_env
# agent_run_state:
# 0=agent running w/ key
# 1=agent w/o key
# 2=agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)
if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi
unset env

# Add tab completion for SSH hostnames based on ~/.ssh/config,
# ignoring wildcards
if [ -e "$HOME/.ssh/config" ]; then
    complete \
        -o "default" \
        -o "nospace" \
        -W "$( \
                grep "^Host" ~/.ssh/config \
              | grep -v "[?*]" \
              | cut -d " " -f2- \
              | tr ' ' '\n' \
            )" \
        scp sftp ssh
fi

# Setup pyenv on MacOS
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
