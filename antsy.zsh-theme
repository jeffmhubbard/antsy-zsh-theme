# antsy.zsh-theme
#
# optional plugins: git virtualenv vi-mode

# defaults
HOST_ICON=${ANTSY_HOST_ICON:-""}
HOST_COLOR=${ANTSY_HOST_COLOR:-"%B%F{green}"}
ROOT_ICON=${ANTSY_ROOT_ICON:-""}
ROOT_COLOR=${ANTSY_ROOT_COLOR:-"%B%F{red}"}
PATH_ICON=${ANTSY_PATH_ICON:-""}
PATH_COLOR=${ANTSY_PATH_COLOR:-"%B%F{blue}"}
PATH_FORMAT=${ANTSY_PATH_FORMAT:-"%3~"}
GIT_ICON=${ANTSY_GIT_ICON:-" "}
GIT_COLOR=${ANTSY_GIT_COLOR:-"%B%F{red}"}
JOBS_ICON=${ANTSY_JOBS_ICON:-" "}
JOBS_COLOR=${ANTSY_JOBS_COLOR:-"%B%F{yellow}"}
TIME_ICON=${ANTSY_TIME_ICON:-""}
TIME_COLOR=${ANTSY_TIME_COLOR:-"%B%F{black}"}
VENV_ICON=${ANTSY_VENV_ICON:-""}
VENV_COLOR=${ANTSY_VENV_COLOR:-"%B%F{cyan}"}
VIM_ICON=${ANTSY_VIM_ICON:-"➜"}
VIM_COLOR=${ANTSY_VIM_COLOR:-"%B%F{white}"}
VIM_COLOR_ALT=${ANTSY_VIM_COLOR_ALT:-"%F{cyan}"}
PROMPT_ICON=${ANTSY_PROMPT_ICON:-"%#"}
PROMPT_COLOR=${ANTSY_PROMPT_COLOR:-"%B%F{white}"}
STATUS_ICON=${ANTSY_STATUS_ICON:-"↵"}
STATUS_COLOR=${ANTSY_STATUS_COLOR:-"%B%F{red}"}
CONTINUE_ICON=${ANTSY_CONTINUE_ICON:-"..."}
CONTINUE_COLOR=${ANTSY_CONTINUE_COLOR:-"%B%F{black}"}
SELECT_ICON=${ANTSY_SELECT_ICON:-"➜ ?"}
SELECT_COLOR=${ANTSY_SELECT_COLOR:-"%B%F{white}"}
MARKER_COLOR=${ANTSY_MARKER_COLOR:-"%B%F{black}"}

# git
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_ADDED=" ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED=" ●"
ZSH_THEME_GIT_PROMPT_DELETED=" ✖"
ZSH_THEME_GIT_PROMPT_RENAMED=" ➤"
ZSH_THEME_GIT_PROMPT_UNMERGED=" ♦"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" ✱"
ZSH_THEME_GIT_PROMPT_AHEAD=" ▲"

# virtualenv
ZSH_THEME_VIRTUALENV_PREFIX="("
ZSH_THEME_VIRTUALENV_SUFFIX=")"

# vi-mode
MODE_INDICATOR=${VIM_COLOR_ALT}

# end string format
typeset -g endf="%f%b"

# show user and hostname (user@host)
function _antsy_userhost {
    local icon color user host
    icon=${HOST_ICON}
    color=${HOST_COLOR}
    user="${color}$(_fmt_username)%n"
    host="${color}@%m"

    echo "${user}${host}${endf} "
}

# returns user or root
function _fmt_username {
    local icon color icon_root
    icon=${HOST_ICON}
    color=${ROOT_COLOR}
    icon_root=${ROOT_ICON}

    if [ $UID -eq 0 ]; then
        echo "${color}${icon_root}"
    else
        echo "${icon}"
    fi
}

# show current path
function _antsy_path {
    local icon color pathfmt
    icon=${PATH_ICON}
    color=${PATH_COLOR}
    pathfmt=${PATH_FORMAT}

    echo "${color}${icon}${pathfmt}${endf} "
}

# show git info (branch and status)
function _antsy_gitinfo {
    if typeset -f git_prompt_info >/dev/null; then
        local icon color
        local branch state
        icon=${GIT_ICON}
        color=${GIT_COLOR}
        branch=$(git_prompt_info)
        state=$(git_prompt_status)

        if [[ -n $branch ]]; then
            echo "${color}${icon}${branch}${state}${endf} "
        fi
    fi
}

# show background jobs
function _antsy_jobs {
    local icon color running
    icon=${JOBS_ICON}
    color=${JOBS_COLOR}
    running=$(jobs -l | wc -l)

    if [[ $running -ne 0 ]]; then
        echo "${color}${icon}${running}${endf} "
    fi
}

# show timestamp
function _antsy_timestamp {
    local icon color
    icon=${TIME_ICON}
    color=${TIME_COLOR}
    
    echo "${color}${icon}%D{%H:%M:%S}${endf}"
}

# show python virtualenv
function _antsy_virtualenv {
    if typeset -f virtualenv_prompt_info >/dev/null; then
        local icon color venv
        icon=${VENV_ICON}
        color=${VENV_COLOR}
        venv="$(virtualenv_prompt_info | sed 's/[\)\(]//g')"

        if [[ -n $venv ]]; then
            echo "${color}${icon}${venv}${endf} "
        fi
    fi
}

# show vi-mode
function _antsy_vimode {
    if typeset -f vi_mode_prompt_info >/dev/null; then
        local icon color
        icon=${VIM_ICON}
        color=${VIM_COLOR}

        echo "${color}$(vi_mode_prompt_info)${icon}${endf} "
    fi
}

# show prompt
function _antsy_prompt {
    local icon color
    icon=${PROMPT_ICON}
    color=${PROMPT_COLOR}

    echo "${color}${icon}${endf} "
}

# show exit status
function _antsy_status {
    local icon color
    icon=${STATUS_ICON}
    color=${STATUS_COLOR}

    echo "${color}%(?..%? ${icon})${endf}"
}

# show continue prompt (PS2)
function _antsy_continue {
    local icon color
    icon=${CONTINUE_ICON}
    color=${CONTINUE_COLOR}

    echo "${color}${icon}${endf} "
}

# show select prompt (PS3)
function _antsy_select {
    local icon color
    icon=${SELECT_ICON}
    color=${SELECT_COLOR}

    echo "${color}${icon}${endf} "
}

# show output marker
function _antsy_marker {
    local icon color width
    local icon_len prefix_len
    local marker marker_prefix
    icon=${ANTSY_MARKER_ICON}
    color=${MARKER_COLOR}
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

    echo "${color}${marker_prefix}$(repeat $width printf "$marker")${endf}"
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
    prompt_left="$(_antsy_userhost)$(_antsy_path)$(_antsy_gitinfo)"

    # first line right
    prompt_right="$(_antsy_jobs)$(_antsy_timestamp)"

    left_length=${#${(S%%)prompt_left//(\%([KF1]|)\{*\}|\%[Bbkf])}}
    right_length=${#${(S%%)prompt_right//(\%([KF1]|)\{*\}|\%[Bbkf])}}
    spacer=$((COLUMNS - left_length - right_length))

    # display
    print -Pr "$prompt_left${(l:$spacer:)}$prompt_right"
}

# [ virtualenv, vi-mode, prompt ], input, [ exit code ]
# second line left
PS1='$(_antsy_virtualenv)$(_antsy_vimode)$(_antsy_prompt)'

# second line right
RPS1='$(_antsy_status)'

# continuation dots
PS2='$(_antsy_continue)'

# select
PS3='$(_antsy_select)'

# vim: set ft=zsh:
