# antsy.zsh-theme
#
# plugins: git virtualenv vi-mode

# defaults
HOST_ICON=""
HOST_COLOR="%F{green}"
ROOT_ICON=""
ROOT_COLOR="%F{red}"
PATH_ICON=""
PATH_COLOR="%F{blue}"
GIT_ICON=' '
GIT_COLOR="%F{red}"
JOBS_ICON=" "
JOBS_COLOR="%F{yellow}"
TIME_ICON=""
TIME_COLOR="%F{black}"
VENV_ICON=""
VENV_COLOR="%F{cyan}"
VIM_ICON="➜"
VIM_COLOR="%F{white}"
PROMPT_ICON="%#"
PROMPT_COLOR="%F{white}"
STATUS_ICON="↵"
STATUS_COLOR="%F{red}"
CONTINUE_ICON="..."
CONTINUE_COLOR="%F{black}"
SELECT_ICON="➜ ?"
SELECT_COLOR="%F{white}"
MARKER_ICON="─" # U+2500
MARKER_COLOR="%B%F{black}"

# git
ZSH_THEME_GIT_PROMPT_PREFIX=''
ZSH_THEME_GIT_PROMPT_SUFFIX=''
ZSH_THEME_GIT_PROMPT_DIRTY=''
ZSH_THEME_GIT_PROMPT_CLEAN=''
ZSH_THEME_GIT_PROMPT_ADDED=' ✚'
ZSH_THEME_GIT_PROMPT_MODIFIED=' ●'
ZSH_THEME_GIT_PROMPT_DELETED=' ✖'
ZSH_THEME_GIT_PROMPT_RENAMED=' ➤'
ZSH_THEME_GIT_PROMPT_UNMERGED=' ♦'
ZSH_THEME_GIT_PROMPT_UNTRACKED=' ✱'
ZSH_THEME_GIT_PROMPT_AHEAD=' ▲'

# virtualenv
ZSH_THEME_VIRTUALENV_PREFIX="("
ZSH_THEME_VIRTUALENV_SUFFIX=")"

# vi-mode
MODE_INDICATOR="%F{cyan}"

# show user and hostname (user@host)
function _antsy_userhost {
    local icon color user host
    icon=${ANTSY_HOST_ICON:-$HOST_ICON}
    color=${ANTSY_HOST_COLOR:-$HOST_COLOR}
    user="${color}$(_antsy_username)%n%f"
    host="${color}@%m%f "

    echo "${user}${host}"
}

# returns user or root
function _antsy_username {
    local icon color icon_root
    icon=${ANTSY_HOST_ICON:-$HOST_ICON}
    color=${ANTSY_ROOT_COLOR:-$ROOT_COLOR}
    icon_root=${ANTSY_ROOT_ICON:-$ROOT_ICON}

    if [ $UID -eq 0 ]; then
        echo "${color}${icon_root}"
    else
        echo "${icon}"
    fi
}

# show current path
function _antsy_path {
    local icon color
    icon=${ANTSY_PATH_ICON:-$PATH_ICON}
    color=${ANTSY_PATH_COLOR:-$PATH_COLOR}

    echo "${color}${icon}%47<...<%~%<<% %f "
}

# show git info (branch and status)
function _antsy_gitinfo {
    local icon color
    local branch state
    branch=$(git_prompt_info)
    state=$(git_prompt_status)
    icon=${ANTSY_GIT_ICON:-$GIT_ICON}
    color=${ANTSY_GIT_COLOR:-$GIT_COLOR}

    if [[ -n $branch ]]; then
        echo "${color}${icon}${branch}${state}%f "
    fi
}

# show background jobs
function _antsy_jobs {
    local icon color running
    icon=${ANTSY_JOBS_ICON:-$JOBS_ICON}
    color=${ANTSY_JOBS_COLOR:-$JOBS_COLOR}
    running=$(jobs -l | wc -l)

    if [[ $running -ne 0 ]]; then
        echo "${color}${icon}${running}%f "
    fi
}

# show timestamp
function _antsy_timestamp {
    local icon color
    icon=${ANTSY_TIME_ICON:-$TIME_ICON}
    color=${ANTSY_TIME_COLOR:-$TIME_COLOR}
    
    echo "${color}${icon}%D{%H:%M:%S}%f"
}

# show python virtualenv
function _antsy_virtualenv {
    local icon color venv
    icon=${ANTSY_VENV_ICON:-$VENV_ICON}
    color=${ANTSY_VENV_COLOR:-$VENV_COLOR}
    venv="$(virtualenv_prompt_info | sed 's/[\)\(]//g')"

    if [[ -n $venv ]]; then
        echo "${color}${icon}${venv}%f "
    fi
}

# show vi-mode
function _antsy_vimode {
    local icon color
    icon=${ANTSY_VIM_ICON:-$VIM_ICON}
    color=${ANTSY_VIM_COLOR:-$VIM_COLOR}

    echo "${color}$(vi_mode_prompt_info)${icon}%f "
}

# show prompt
function _antsy_prompt {
    local icon color
    icon=${ANTSY_PROMPT_ICON:-$PROMPT_ICON}
    color=${ANTSY_PROMPT_COLOR:-$PROMPT_COLOR}

    echo "${color}${icon}%f "
}

# show exit status
function _antsy_status {
    local icon color
    icon=${ANTSY_STATUS_ICON:-$STATUS_ICON}
    color=${ANTSY_STATUS_COLOR:-$STATUS_COLOR}

    echo "${color}%(?..%? ${icon})%f"
}

# show continue prompt (PS2)
function _antsy_continue {
    local icon color
    icon=${ANTSY_CONTINUE_ICON:-$CONTINUE_ICON}
    color=${ANTSY_CONTINUE_COLOR:-$CONTINUE_COLOR}

    echo "${color}${icon}%f "
}

# show select prompt (PS3)
function _antsy_select {
    local icon color
    icon=${ANTSY_SELECT_ICON:-$SELECT_ICON}
    color=${ANTSY_SELECT_COLOR:-$SELECT_COLOR}

    echo "${color}${icon}%f "
}

# show output marker
function _antsy_marker {
    local icon color width
    local icon_len prefix_len
    local marker marker_prefix
    icon=${ANTSY_MARKER_ICON:-$MARKER_ICON}
    color=${ANTSY_MARKER_COLOR:-$MARKER_COLOR}
    width=$COLUMNS

    icon_len=$(echo -n "$icon" | wc -m)
    if [[ $icon_len -gt 1 ]]; then
        prefix_len=$((icon_len - 1))
        width=$((width - prefix_len))
        marker_prefix=${icon[1,$prefix_len]}
        marker=${icon/$marker_prefix/}
    else
        marker_prefix=""
        marker=$icon
    fi

    echo "${color}${marker_prefix}$(repeat $width printf "$marker")%f%b"
}

function precmd {
    local prompt_left left_length
    local prompt_right right_length
    local spacer

    # output marker
    if [[ -v ANTSY_MARKER_ICON ]]; then
        print -Pr "$(_antsy_marker)"
    fi

    # [ user@host, pwd, git branch & status ], spacer, [ jobs, timestamp ]
    # first line left
    prompt_left="%B$(_antsy_userhost)$(_antsy_path)$(_antsy_gitinfo)%b"

    # first line right
    prompt_right="%B$(_antsy_jobs)$(_antsy_timestamp)%b"

    left_length=${#${(S%%)prompt_left//(\%([KF1]|)\{*\}|\%[Bbkf])}}
    right_length=${#${(S%%)prompt_right//(\%([KF1]|)\{*\}|\%[Bbkf])}}
    spacer=$((COLUMNS - left_length - right_length))

    # display
    print -Pr "$prompt_left${(l:$spacer:)}$prompt_right"
}

# [ virtualenv, vi-mode, prompt ], input, [ exit code ]
# second line left
PS1='%B$(_antsy_virtualenv)$(_antsy_vimode)$(_antsy_prompt)%b'

# second line right
RPS1="%B$(_antsy_status)%b"

# continuation dots
PS2="%B$(_antsy_continue)%b"

# select
PS3="%B$(_antsy_select)%b"

# vim: set ft=zsh:
