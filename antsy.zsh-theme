# antsy.zsh-theme

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

showjobs(){
    local running=$(jobs -l | wc -l)
    if [[ $running -ne 0 ]]; then
        echo "%F{yellow} $running%f "
    fi
}

# first line
precmd(){

    # root
    if [ $UID -eq 0 ]; then
        admin="%F{red}"
    fi

    # user@host, pwd, git branch and status
    local preprompt_left="%B%F{green}$admin%n%F{green}@%m %B%F{blue}%47<...<%~%<<% %B%F{red}%(?..%? ↵) $(git_prompt_info)%B%F{red}$(git_prompt_status)%f%b"

    # timestamp
    local preprompt_right="%B$(showjobs)%F{black}%D{%H:%M:%S}%f%b"

    # calculate spaces
    local preprompt_left_length=${#${(S%%)preprompt_left//(\%([KF1]|)\{*\}|\%[Bbkf])}}
    local preprompt_right_length=${#${(S%%)preprompt_right//(\%([KF1]|)\{*\}|\%[Bbkf])}}
    local num_filler_spaces=$((COLUMNS - preprompt_left_length - preprompt_right_length))

    # display
    print -Pr "$preprompt_left${(l:$num_filler_spaces:)}$preprompt_right"
}

# virtualenv, vi-mode, prompt
PS1='%B%F{cyan}$(virtualenv_prompt_info)%F{white}$(vi_mode_prompt_info)➜ %F{white}%#%f%b '

# exit code
RPS1="%B%F{red}%(?..%? ↵)%f%b"

# continuation dots
PS2="%B%F{black}...%b%f "

# vim: set ft=zsh:
