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

# jobs count
function showjobs() {
    local running=$(jobs -l | wc -l)
    if [[ $running -ne 0 ]]; then
        echo "%F{yellow} $running%f "
    fi
}

# detect root
function showroot() {
    if [ $UID -eq 0 ]; then
        echo "%F{red}"
    fi
}

# first line
# [ user@host, pwd, git branch & status ], spacer, [ jobs, timestamp ]
function precmd(){

    # left side
    local preprompt_left="%B%F{green}$(showroot)%n%F{green}@%m %B%F{blue}%47<...<%~%<<% %B%F{red}%(?..%? ↵) $(git_prompt_info)%B%F{red}$(git_prompt_status)%f%b"

    # right side
    local preprompt_right="%B$(showjobs)%F{black}%D{%H:%M:%S}%f%b"

    # calculate spaces
    local preprompt_left_length=${#${(S%%)preprompt_left//(\%([KF1]|)\{*\}|\%[Bbkf])}}
    local preprompt_right_length=${#${(S%%)preprompt_right//(\%([KF1]|)\{*\}|\%[Bbkf])}}
    local num_filler_spaces=$((COLUMNS - preprompt_left_length - preprompt_right_length))

    # display
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
