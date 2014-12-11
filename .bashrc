[ -z "$PS1" ] && return

HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

# Turn off history expansion
set +H

shopt -s histappend
shopt -s checkwinsize

VIRTUALENVWRAPPER_SRC=/usr/local/bin/virtualenvwrapper.sh
if [ -f $VIRTUALENVWRAPPER_SRC ]; then
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2.7
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/workspace
    source $VIRTUALENVWRAPPER_SRC
fi

# Start/Reuse SSH Agent - restart or re-use an existing agent
SSH_AGENT_CACHE=/tmp/ssh_agent_eval_`whoami`
if [ -s "${SSH_AGENT_CACHE}" ]; then
    echo "Reusing existing ssh-agent"
    eval `cat "${SSH_AGENT_CACHE}"`
    # Check that agent still exists
    kill -0 "${SSH_AGENT_PID}"

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
export PS1="\u@\h# "

alias g='git'
alias ga='git add'
alias gc='git commit -av'
alias gd='git diff --color=auto'
alias gp='git pull'
alias gpp='git push origin HEAD'
alias gs='git status'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias n='nosetests -s --nologcapture'
alias grep='grep --color=auto'
alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs -nw'
alias e='/Applications/Emacs.app/Contents/MacOS/Emacs -nw'
alias vs='vagrant ssh'
alias vu='vagrant up'

# export DOCKER_HOST=tcp://192.168.59.103:2376
# export DOCKER_CERT_PATH=/Users/mlp/.boot2docker/certs/boot2docker-vm
# export DOCKER_TLS_VERIFY=1
$(boot2docker shellinit)
