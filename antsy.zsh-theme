# antsy.zsh-theme
#
# optional plugins: git virtualenv vi-mode

setopt prompt_subst

# defaults
typeset -A ANTSY=( \
    [USER_ICON]="" \
    [USER_COLOR]="%B%F{green}" \
    [HOST_COLOR]="%B%F{green}" \
    [ROOT_ICON]="" \
    [ROOT_COLOR]="%B%F{red}" \
    [PATH_ICON]="" \
    [PATH_COLOR]="%B%F{blue}" \
    [PATH_FORMAT]="%3~" \
    [GIT_ICON]=" " \
    [GIT_COLOR]="%B%F{red}" \
    [GIT_SHA_COLOR]="%B%F{red}" \
    [GIT_STATE_COLOR]="%B%F{red}" \
    [GIT_STATE_ADDED]=" ✚" \
    [GIT_STATE_MODIFIED]=" ●" \
    [GIT_STATE_DELETED]=" ✖" \
    [GIT_STATE_RENAMED]=" ➤" \
    [GIT_STATE_UNMERGED]=" ♦" \
    [GIT_STATE_UNTRACKED]=" ✱" \
    [GIT_STATE_AHEAD]=" ▲" \
    [JOBS_ICON]=" " \
    [JOBS_COLOR]="%B%F{yellow}" \
    [HISTORY_ICON]="" \
    [HISTORY_COLOR]="%B%F{black}" \
    [TIME_ICON]="" \
    [TIME_COLOR]="%B%F{black}" \
    [VENV_ICON]="" \
    [VENV_COLOR]="%B%F{cyan}" \
    [VIM_ICON]="➜" \
    [VIM_COLOR]="%B%F{white}" \
    [VIM_COLOR_ALT]="%F{cyan}" \
    [PROMPT_ICON]="%#" \
    [PROMPT_COLOR]="%B%F{white}" \
    [STATUS_ICON]="↵" \
    [STATUS_COLOR]="%B%F{red}" \
    [CONTINUE_ICON]="..." \
    [CONTINUE_COLOR]="%B%F{black}" \
    [SELECT_ICON]="➜ ?" \
    [SELECT_COLOR]="%B%F{white}" \
    [MARKER_COLOR]="%B%F{black}" \
)

# end string format
endf="%f%b"

# show user and hostname (user@host)
function _antsy_userhost {
    local icon color color_host
    icon=${ANTSY_USER_ICON:-$ANTSY[USER_ICON]}
    color=${ANTSY_USER_COLOR:-$ANTSY[USER_COLOR]}
    color_host=${ANTSY_HOST_COLOR:-$ANTSY[HOST_COLOR]}

    # detect root
    if [ $UID -eq 0 ]; then
        icon=${ANTSY_ROOT_ICON:-$ANTSY[ROOT_ICON]}
        color=${ANTSY_ROOT_COLOR:-$ANTSY[ROOT_COLOR]}
    fi

    echo "${color}${icon}%n${color_host}@%m${endf} "
}

# show current path
function _antsy_path {
    local icon color pathfmt
    icon=${ANTSY_PATH_ICON:-$ANTSY[PATH_ICON]}
    color=${ANTSY_PATH_COLOR:-$ANTSY[PATH_COLOR]}
    pathfmt=${ANTSY_PATH_FORMAT:-$ANTSY[PATH_FORMAT]}

    echo "${color}${icon}${pathfmt}${endf} "
}

# show git info (branch, commit, and status)
# ANTSY_GIT_SHA_ICON must be set to display commit hash
function _antsy_gitinfo {
    if typeset -f git_prompt_info >/dev/null; then
        typeset -g ZSH_THEME_GIT_PROMPT_PREFIX=""
        typeset -g ZSH_THEME_GIT_PROMPT_SUFFIX=""
        typeset -g ZSH_THEME_GIT_PROMPT_DIRTY=""
        typeset -g ZSH_THEME_GIT_PROMPT_CLEAN=""
        typeset -g ZSH_THEME_GIT_PROMPT_ADDED=${ANTSY_GIT_STATE_ADDED:-$ANTSY[GIT_STATE_ADDED]}
        typeset -g ZSH_THEME_GIT_PROMPT_MODIFIED=${ANTSY_GIT_STATE_MODIFIED:-$ANTSY[GIT_STATE_MODIFIED]}
        typeset -g ZSH_THEME_GIT_PROMPT_DELETED=${ANTSY_GIT_STATE_DELETED:-$ANTSY[GIT_STATE_DELETED]}
        typeset -g ZSH_THEME_GIT_PROMPT_RENAMED=${ANTSY_GIT_STATE_RENAMED:-$ANTSY[GIT_STATE_RENAMED]}
        typeset -g ZSH_THEME_GIT_PROMPT_UNMERGED=${ANTSY_GIT_STATE_UNMERGED:-$ANTSY[GIT_STATE_UNMERGED]}
        typeset -g ZSH_THEME_GIT_PROMPT_UNTRACKED=${ANTSY_GIT_STATE_UNTRACKED:-$ANTSY[GIT_STATE_UNTRACKED]}
        typeset -g ZSH_THEME_GIT_PROMPT_AHEAD=${ANTSY_GIT_STATE_AHEAD:-$ANTSY[GIT_STATE_AHEAD]}

        local icon color state_color
        local branch state commit
        local sha_icon sha_color
        icon=${ANTSY_GIT_ICON:-$ANTSY[GIT_ICON]}
        color=${ANTSY_GIT_COLOR:-$ANTSY[GIT_COLOR]}
        branch=$(git_prompt_info)
        state=$(git_prompt_status)
        state_color=${ANTSY_GIT_STATE_COLOR:-$ANTSY[GIT_STATE_COLOR]}

        if [[ -n $branch ]]; then
            if [[ -v ANTSY_GIT_SHA_ICON ]]; then
                sha_icon=${ANTSY_GIT_SHA_ICON}
                sha_color=${ANTSY_GIT_SHA_COLOR:-$ANTSY[GIT_SHA_COLOR]}
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
    icon=${ANTSY_JOBS_ICON:-$ANTSY[JOBS_ICON]}
    color=${ANTSY_JOBS_COLOR:-$ANTSY[JOBS_COLOR]}
    running=$(jobs -l | wc -l)

    if [[ $running -ne 0 ]]; then
        echo "${color}${icon}${running}${endf} "
    fi
}

# show current history
function _antsy_history {
    local icon color running
    icon=${ANTSY_HISTORY_ICON:-$ANTSY[HISTORY_ICON]}
    color=${ANTSY_HISTORY_COLOR:-$ANTSY[HISTORY_COLOR]}

    if [[ -v ANTSY_HISTORY_ICON ]]; then
        echo "${color}${icon}%!${endf} "
    fi
}

# show timestamp
function _antsy_timestamp {
    local icon color
    icon=${ANTSY_TIME_ICON:-$ANTSY[TIME_ICON]}
    color=${ANTSY_TIME_COLOR:-$ANTSY[TIME_COLOR]}
    
    echo "${color}${icon}%D{%H:%M:%S}${endf}"
}

# show python virtualenv
function _antsy_virtualenv {
    if typeset -f virtualenv_prompt_info >/dev/null; then
        local icon color venv
        icon=${ANTSY_VENV_ICON:-$ANTSY[VENV_ICON]}
        color=${ANTSY_VENV_COLOR:-$ANTSY[VENV_COLOR]}
        venv="$(virtualenv_prompt_info | sed 's/[][]//g')"

        if [[ -n $venv ]]; then
            echo "${color}${icon}${venv}${endf} "
        fi
    fi
}

# show vi-mode
function _antsy_vimode {
    if typeset -f vi_mode_prompt_info >/dev/null; then
        typeset -g MODE_INDICATOR=${ANTSY_VIM_COLOR_ALT:-$ANTSY[VIM_COLOR_ALT]}

        local icon color
        icon=${ANTSY_VIM_ICON:-$ANTSY[VIM_ICON]}
        color=${ANTSY_VIM_COLOR:-$ANTSY[VIM_COLOR]}

        echo "${color}$(vi_mode_prompt_info)${icon}${endf} "
    fi
}

# show prompt
function _antsy_prompt {
    local icon color
    icon=${ANTSY_PROMPT_ICON:-$ANTSY[PROMPT_ICON]}
    color=${ANTSY_PROMPT_COLOR:-$ANTSY[PROMPT_COLOR]}

    echo "${color}${icon}${endf} "
}

# show exit status
function _antsy_status {
    local icon color
    icon=${ANTSY_STATUS_ICON:-$ANTSY[STATUS_ICON]}
    color=${ANTSY_STATUS_COLOR:-$ANTSY[STATUS_COLOR]}

    echo "${color}%(?..%? ${icon})${endf}"
}

# show continue prompt (PS2)
function _antsy_continue {
    local icon color
    icon=${ANTSY_CONTINUE_ICON:-$ANTSY[CONTINUE_ICON]}
    color=${ANTSY_CONTINUE_COLOR:-$ANTSY[CONTINUE_COLOR]}

    echo "${color}${icon}${endf} "
}

# show select prompt (PS3)
function _antsy_select {
    local icon color
    icon=${ANTSY_SELECT_ICON:-$ANTSY[SELECT_ICON]}
    color=${ANTSY_SELECT_COLOR:-$ANTSY[SELECT_COLOR]}

    echo "${color}${icon}${endf} "
}

# show output marker
function _antsy_marker {
    local icon color width
    local icon_len prefix_len
    local marker prefix
    icon=${ANTSY_MARKER_ICON}
    color=${ANTSY_MARKER_COLOR:-$ANTSY[MARKER_COLOR]}
    width=$COLUMNS
    icon_len=$(echo -n "$icon" | wc -m)

    # if icon is more than one character
    # recalculate width and set set prefix
    if [[ $icon_len -gt 1 ]]; then
        prefix_len=$((icon_len - 1))
        width=$((width - prefix_len))
        prefix=${icon[1,$prefix_len]}
        marker=${icon/$prefix/}
    else
        marker=${icon}
    fi

    echo "${color}${prefix}$(repeat $width printf "$marker")${endf}"
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
    prompt_right="$(_antsy_jobs)$(_antsy_history)$(_antsy_timestamp)"

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
