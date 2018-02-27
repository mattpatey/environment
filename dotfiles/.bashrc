[ -z "$PS1" ] && return

HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

# Turn off history expansion
set +H

shopt -s histappend
shopt -s checkwinsize

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
    ssh-add
fi

export EDITOR="emacs -Q -nw"
export PATH="$PATH:/usr/local/ruby/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$HOME/bin"
export PS1="\u@\h# "
export GIT="/usr/bin/git"

# Configure locale
LANG=en_US.UTF-8
LANGUAGE=en_US:
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC=en_US.UTF-8
LC_TIME=en_US.UTF-8
LC_COLLATE="en_US.UTF-8"
LC_MONETARY=en_US.UTF-8
LC_MESSAGES=POSIX
LC_PAPER=en_US.UTF-8
LC_NAME=en_US.UTF-8
LC_ADDRESS=en_US.UTF-8
LC_TELEPHONE=en_US.UTF-8
LC_MEASUREMENT=de_DE.UTF-8
LC_IDENTIFICATION=en_US.UTF-8
LC_ALL=en_US.UTF-8

alias ll='ls -alF --color=always'
alias ap='ansible-playbook --diff'
alias r='~/bin/remote-session.sh'
alias m='/usr/bin/mutt'
alias gs='/usr/bin/git status'
alias e='emacs'
alias gci='git commit --interactive --verbose'

function gc() {
    local files="${@}"

    ${GIT} commit -v ${files}
}

function gd() {
    local file="${1:-}"

    ${GIT} diff ${file}
}

function gcm() {
    local msg="${1:?Missing commit message}"
    local file="${2:?Missing file}"

    ${GIT} commit -m "${msg}" ${2}
}

source ~/.bash_env
