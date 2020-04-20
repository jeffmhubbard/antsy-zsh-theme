# antsy.zsh-theme
#
# plugins: git virtualenv vi-mode

# git
ZSH_THEME_GIT_PROMPT_PREFIX=' '
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
ZSH_THEME_VIRTUALENV_SUFFIX=") "

# vi-mode
MODE_INDICATOR="%F{cyan}"

# output marker
MARKER_CHAR="─" # U+2500
MARKER_COLOR="%B%F{black}"

# jobs count
function _show_jobs {
    local running=$(jobs -l | wc -l)
    if [[ $running -ne 0 ]]; then
        echo "%F{yellow} $running%f "
    fi
}

# detect root
function _show_root {
    if [ $UID -eq 0 ]; then
        echo "%F{red}"
    fi
}

# draw output marker
function _show_marker {
    local char=${ANTSY_MARKER_CHAR:-$MARKER_CHAR}
    local color=${ANTSY_MARKER_COLOR:-$MARKER_COLOR}
    local width=$COLUMNS
    local marker marker_prefix

    local char_len=$(echo -n $char | wc -m)
    if [[ $char_len -gt 1 ]]; then
        local prefix_len=$(($char_len - 1))
        width=$(($width - $prefix_len))
        marker_prefix=$char[1,$prefix_len]
        marker=${char/$marker_prefix/}
    else
        marker_prefix=""
        marker=$char
    fi

    echo "${color}${marker_prefix}$(repeat $width printf "$marker")%f%b"
}

function precmd(){

    # output marker
    if [[ -v ANTSY_SHOW_MARKER ]]; then
        print -Pr "$(_show_marker)"
    fi

    # first line left
    local preprompt_left="%B%F{green}$(_show_root)%n%F{green}@%m %B%F{blue}%47<...<%~%<<% %B%F{red}%(?..%? ↵) $(git_prompt_info)%B%F{red}$(git_prompt_status)%f%b"

    # first line right
    local preprompt_right="%B$(_show_jobs)%F{black}%D{%H:%M:%S}%f%b"

    # calculate spacer
    local preprompt_left_length=${#${(S%%)preprompt_left//(\%([KF1]|)\{*\}|\%[Bbkf])}}
    local preprompt_right_length=${#${(S%%)preprompt_right//(\%([KF1]|)\{*\}|\%[Bbkf])}}
    local num_filler_spaces=$((COLUMNS - preprompt_left_length - preprompt_right_length))

    # display
    # [ user@host, pwd, git branch & status ], spacer, [ jobs, timestamp ]
    print -Pr "$preprompt_left${(l:$num_filler_spaces:)}$preprompt_right"
}

# second line left
# virtualenv, vi-mode, prompt
PS1='%B%F{cyan}$(virtualenv_prompt_info)%F{white}$(vi_mode_prompt_info)➜ %F{white}%#%f%b '

# second line right
# exit code
RPS1="%B%F{red}%(?..%? ↵)%f%b"

# continuation dots
PS2="%B%F{black}...%b%f "

# select
PS3="%B%F{black}➜ %F{white}?%b%f "

# vim: set ft=zsh:
