[ -z "$PS1" ] && return

HISTCONTROL=ignoredups:ignorespace

shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

shopt -s checkwinsize

if [ -f /usr/bin/virtualenvwrapper.sh ]; then
    VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2.7
    source /usr/bin/virtualenvwrapper.sh
fi

# Turn off history expansion
set +H

# Start/Reuse SSH Agent - restart or re-use an existing agent
SSH_AGENT_CACHE=/tmp/ssh_agent_eval_`whoami`
if [ -s "${SSH_AGENT_CACHE}" ]; then
    echo "Reusing existing ssh-agent"
    eval `cat "${SSH_AGENT_CACHE}"`
    # Check that agent still exists
    kill -0 "${SSH_AGENT_PID}" 2>-

    if [ $? -eq 1 ]; then
        echo "ssh-agent pid ${SSH_AGENT_PID} no longer running"
        # Looks like the SSH-Agent has died, it'll be restarted below
        rm -f "${SSH_AGENT_CACHE}"
    fi
fi

if [ ! -f "${SSH_AGENT_CACHE}" ]; then
    echo "Starting new ssh-agent"
    touch "${SSH_AGENT_CACHE}"
    chmod 600 "${SSH_AGENT_CACHE}"
    ssh-agent >> "${SSH_AGENT_CACHE}"
    chmod 400 "${SSH_AGENT_CACHE}"
    eval `cat "${SSH_AGENT_CACHE}"`
fi

export EDITOR="emacs -Q"
export PATH="$PATH:/usr/local/ruby/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$HOME/bin"
export PS1="# "
export PYTHONSTARTUP="$HOME/.pystartup"

alias e='emacs -nw'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

source "$HOME/environment/linux"
