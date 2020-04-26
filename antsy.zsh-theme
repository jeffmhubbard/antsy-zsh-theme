# antsy.zsh-theme
#
# optional plugins: git virtualenv vi-mode

# defaults
__USER_ICON=""
__USER_COLOR="%B%F{green}"
__HOST_COLOR="%B%F{green}"
__ROOT_ICON=""
__ROOT_COLOR="%B%F{red}"
__PATH_ICON=""
__PATH_COLOR="%B%F{blue}"
__PATH_FORMAT="%3~"
__GIT_ICON=" "
__GIT_COLOR="%B%F{red}"
__GIT_SHA_COLOR="%B%F{red}"
__GIT_STATE_COLOR="%B%F{red}"
__JOBS_ICON=" "
__JOBS_COLOR="%B%F{yellow}"
__TIME_ICON=""
__TIME_COLOR="%B%F{black}"
__VENV_ICON=""
__VENV_COLOR="%B%F{cyan}"
__VIM_ICON="➜"
__VIM_COLOR="%B%F{white}"
__VIM_COLOR_ALT="%F{cyan}"
__PROMPT_ICON="%#"
__PROMPT_COLOR="%B%F{white}"
__STATUS_ICON="↵"
__STATUS_COLOR="%B%F{red}"
__CONTINUE_ICON="..."
__CONTINUE_COLOR="%B%F{black}"
__SELECT_ICON="➜ ?"
__SELECT_COLOR="%B%F{white}"
__MARKER_COLOR="%B%F{black}"

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
MODE_INDICATOR=${ANTSY_VIM_COLOR_ALT:-$__VIM_COLOR_ALT}

# end string format
endf="%f%b"

# show user and hostname (user@host)
function _antsy_userhost {
    local icon color color_host
    icon=${ANTSY_USER_ICON:-$__USER_ICON}
    color=${ANTSY_USER_COLOR:-$__USER_COLOR}
    color_host=${ANTSY_HOST_COLOR:-$__HOST_COLOR}

    if [ $UID -eq 0 ]; then
        icon=${ANTSY_ROOT_ICON:-$__ROOT_ICON}
        color=${ANTSY_ROOT_COLOR:-$__ROOT_COLOR}
    fi

    echo "${color}${icon}%n${color_host}@%m${endf} "
}

# show current path
function _antsy_path {
    local icon color pathfmt
    icon=${ANTSY_PATH_ICON:-$__PATH_ICON}
    color=${ANTSY_PATH_COLOR:-$__PATH_COLOR}
    pathfmt=${ANTSY_PATH_FORMAT:-$__PATH_FORMAT}

    echo "${color}${icon}${pathfmt}${endf} "
}

# show git info (branch and status)
function _antsy_gitinfo {
    if typeset -f git_prompt_info >/dev/null; then
        local icon color state_color
        local branch state commit
        local sha_icon sha_color
        icon=${ANTSY_GIT_ICON:-$__GIT_ICON}
        color=${ANTSY_GIT_COLOR:-$__GIT_COLOR}
        branch=$(git_prompt_info)
        state=$(git_prompt_status)
        state_color=${ANTSY_GIT_STATE_COLOR:-$__GIT_STATE_COLOR}

        if [[ -n $branch ]]; then
            if [[ -v ANTSY_GIT_SHA_ICON ]]; then
                sha_icon=${ANTSY_GIT_SHA_ICON}
                sha_color=${ANTSY_GIT_SHA_COLOR:-$__GIT_SHA_COLOR}
                sha_short=$(git_prompt_short_sha)
                commit="${sha_color}${sha_icon}${sha_short}${endf}"
            fi

            echo "${color}${icon}${branch}${commit}${state_color}${state}${endf} "
        fi
    fi
}

# show background jobs
function _antsy_jobs {
    local icon color running
    icon=${ANTSY_JOBS_ICON:-$__JOBS_ICON}
    color=${ANTSY_JOBS_COLOR:-$__JOBS_COLOR}
    running=$(jobs -l | wc -l)

    if [[ $running -ne 0 ]]; then
        echo "${color}${icon}${running}${endf} "
    fi
}

# show timestamp
function _antsy_timestamp {
    local icon color
    icon=${ANTSY_TIME_ICON:-$__TIME_ICON}
    color=${ANTSY_TIME_COLOR:-$__TIME_COLOR}
    
    echo "${color}${icon}%D{%H:%M:%S}${endf}"
}

# show python virtualenv
function _antsy_virtualenv {
    if typeset -f virtualenv_prompt_info >/dev/null; then
        local icon color venv
        icon=${ANTSY_VENV_ICON:-$__VENV_ICON}
        color=${ANTSY_VENV_COLOR:-$__VENV_COLOR}
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
        icon=${ANTSY_VIM_ICON:-$__VIM_ICON}
        color=${ANTSY_VIM_COLOR:-$__VIM_COLOR}

        echo "${color}$(vi_mode_prompt_info)${icon}${endf} "
    fi
}

# show prompt
function _antsy_prompt {
    local icon color
    icon=${ANTSY_PROMPT_ICON:-$__PROMPT_ICON}
    color=${ANTSY_PROMPT_COLOR:-$__PROMPT_COLOR}

    echo "${color}${icon}${endf} "
}

# show exit status
function _antsy_status {
    local icon color
    icon=${ANTSY_STATUS_ICON:-$__STATUS_ICON}
    color=${ANTSY_STATUS_COLOR:-$__STATUS_COLOR}

    echo "${color}%(?..%? ${icon})${endf}"
}

# show continue prompt (PS2)
function _antsy_continue {
    local icon color
    icon=${ANTSY_CONTINUE_ICON:-$__CONTINUE_ICON}
    color=${ANTSY_CONTINUE_COLOR:-$__CONTINUE_COLOR}

    echo "${color}${icon}${endf} "
}

# show select prompt (PS3)
function _antsy_select {
    local icon color
    icon=${ANTSY_SELECT_ICON:-$__SELECT_ICON}
    color=${ANTSY_SELECT_COLOR:-$__SELECT_COLOR}

    echo "${color}${icon}${endf} "
}

# show output marker
function _antsy_marker {
    local icon color width
    local icon_len prefix_len
    local marker marker_prefix
    icon=${ANTSY_MARKER_ICON}
    color=${ANTSY_MARKER_COLOR:-$__MARKER_COLOR}
    width=$COLUMNS
    icon_len=$(echo -n "$icon" | wc -m)

    if [[ $icon_len -gt 1 ]]; then
        prefix_len=$((icon_len - 1))
        width=$((width - prefix_len))
        marker_prefix=${icon[1,$prefix_len]}
        marker=${icon/$marker_prefix/}
    else
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
