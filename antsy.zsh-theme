# antsy.zsh-theme
#
# optional plugins: git virtualenv vi-mode

# defaults
 __USER_ICON=${ANTSY_USER_ICON:-""}
 __USER_COLOR=${ANTSY_USER_COLOR:-"%B%F{green}"}
 __HOST_COLOR=${ANTSY_HOST_COLOR:-"%B%F{green}"}
 __ROOT_ICON=${ANTSY_ROOT_ICON:-""}
 __ROOT_COLOR=${ANTSY_ROOT_COLOR:-"%B%F{red}"}
 __PATH_ICON=${ANTSY_PATH_ICON:-""}
 __PATH_COLOR=${ANTSY_PATH_COLOR:-"%B%F{blue}"}
 __PATH_FORMAT=${ANTSY_PATH_FORMAT:-"%3~"}
 __GIT_ICON=${ANTSY_GIT_ICON:-" "}
 __GIT_COLOR=${ANTSY_GIT_COLOR:-"%B%F{red}"}
 __GIT_SHA_COLOR=${ANTSY_GIT_SHA_COLOR:-"%B%F{red}"}
 __GIT_STATE_COLOR=${ANTSY_GIT_STATE_COLOR:-"%B%F{red}"}
 __JOBS_ICON=${ANTSY_JOBS_ICON:-" "}
 __JOBS_COLOR=${ANTSY_JOBS_COLOR:-"%B%F{yellow}"}
 __TIME_ICON=${ANTSY_TIME_ICON:-""}
 __TIME_COLOR=${ANTSY_TIME_COLOR:-"%B%F{black}"}
 __VENV_ICON=${ANTSY_VENV_ICON:-""}
 __VENV_COLOR=${ANTSY_VENV_COLOR:-"%B%F{cyan}"}
 __VIM_ICON=${ANTSY_VIM_ICON:-"➜"}
 __VIM_COLOR=${ANTSY_VIM_COLOR:-"%B%F{white}"}
 __VIM_COLOR_ALT=${ANTSY_VIM_COLOR_ALT:-"%F{cyan}"}
 __PROMPT_ICON=${ANTSY_PROMPT_ICON:-"%#"}
 __PROMPT_COLOR=${ANTSY_PROMPT_COLOR:-"%B%F{white}"}
 __STATUS_ICON=${ANTSY_STATUS_ICON:-"↵"}
 __STATUS_COLOR=${ANTSY_STATUS_COLOR:-"%B%F{red}"}
 __CONTINUE_ICON=${ANTSY_CONTINUE_ICON:-"..."}
 __CONTINUE_COLOR=${ANTSY_CONTINUE_COLOR:-"%B%F{black}"}
 __SELECT_ICON=${ANTSY_SELECT_ICON:-"➜ ?"}
 __SELECT_COLOR=${ANTSY_SELECT_COLOR:-"%B%F{white}"}
 __MARKER_COLOR=${ANTSY_MARKER_COLOR:-"%B%F{black}"}

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
MODE_INDICATOR=${__VIM_COLOR_ALT}

# end string format
endf="%f%b"

# show user and hostname (user@host)
function _antsy_userhost {
    local icon color color_host
    icon=${__USER_ICON}
    color=${__USER_COLOR}
    color_host=${__HOST_COLOR}

    if [ $UID -eq 0 ]; then
        icon=${__ROOT_ICON}
        color=${__ROOT_COLOR}
    fi

    echo "${color}${icon}%n${color_host}@%m${endf} "
}

# show current path
function _antsy_path {
    local icon color pathfmt
    icon=${__PATH_ICON}
    color=${__PATH_COLOR}
    pathfmt=${__PATH_FORMAT}

    echo "${color}${icon}${pathfmt}${endf} "
}

# show git info (branch and status)
function _antsy_gitinfo {
    if typeset -f git_prompt_info >/dev/null; then
        local icon color state_color
        local branch state commit
        local sha_icon sha_color
        icon=${__GIT_ICON}
        color=${__GIT_COLOR}
        branch=$(git_prompt_info)
        state=$(git_prompt_status)
        state_color=${__GIT_STATE_COLOR}

        if [[ -n $branch ]]; then
            if [[ -v ANTSY_GIT_SHA_ICON ]]; then
                sha_icon=${ANTSY_GIT_SHA_ICON}
                sha_color=${__GIT_SHA_COLOR}
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
    icon=${__JOBS_ICON}
    color=${__JOBS_COLOR}
    running=$(jobs -l | wc -l)

    if [[ $running -ne 0 ]]; then
        echo "${color}${icon}${running}${endf} "
    fi
}

# show timestamp
function _antsy_timestamp {
    local icon color
    icon=${__TIME_ICON}
    color=${__TIME_COLOR}
    
    echo "${color}${icon}%D{%H:%M:%S}${endf}"
}

# show python virtualenv
function _antsy_virtualenv {
    if typeset -f virtualenv_prompt_info >/dev/null; then
        local icon color venv
        icon=${__VENV_ICON}
        color=${__VENV_COLOR}
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
        icon=${__VIM_ICON}
        color=${__VIM_COLOR}

        echo "${color}$(vi_mode_prompt_info)${icon}${endf} "
    fi
}

# show prompt
function _antsy_prompt {
    local icon color
    icon=${__PROMPT_ICON}
    color=${__PROMPT_COLOR}

    echo "${color}${icon}${endf} "
}

# show exit status
function _antsy_status {
    local icon color
    icon=${__STATUS_ICON}
    color=${__STATUS_COLOR}

    echo "${color}%(?..%? ${icon})${endf}"
}

# show continue prompt (PS2)
function _antsy_continue {
    local icon color
    icon=${__CONTINUE_ICON}
    color=${__CONTINUE_COLOR}

    echo "${color}${icon}${endf} "
}

# show select prompt (PS3)
function _antsy_select {
    local icon color
    icon=${__SELECT_ICON}
    color=${__SELECT_COLOR}

    echo "${color}${icon}${endf} "
}

# show output marker
function _antsy_marker {
    local icon color width
    local icon_len prefix_len
    local marker marker_prefix
    icon=${ANTSY_MARKER_ICON}
    color=${__MARKER_COLOR}
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
