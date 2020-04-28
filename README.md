# antsy-zsh-theme

Multiline `oh-my-zsh` theme with git info, virtualenv, vi-mode indicator, current history, jobs count, and exit status.

~~Intended to be used with a dark, 16-color terminal theme. I use the [Terminal.app or xterm](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors) colors. Tango is okay too.~~

Every component of the prompt can now be customized with colors and "icons" (any glyph or character). 

Default
![Default](https://github.com/jeffmhubbard/antsy-zsh-theme/blob/assets/demo.png)  

Hideous example
![Hideous example](https://github.com/jeffmhubbard/antsy-zsh-theme/blob/assets/demo2.png)  

[![asciicast](https://asciinema.org/a/311469.svg)](https://asciinema.org/a/311469)

#### Installation
##### oh-my-zsh
Get theme
```sh
git clone https://github.com/jeffmhubbard/antsy-zsh-theme
cp antsy-zsh-theme/antsy.zsh-theme $ZSH_CUSTOM/themes
```
Enable theme and plugins (optional) in `.zshrc`.
```sh
ZSH_THEME="antsy"

plugins=( \
    git \
    virtualenv \
    vi-mode \
    ...
)
```

##### Other
This theme can be safely used outside of `oh-my-zsh`, but lacks `git`, `virtualenv`, and `vi-mode` components. Just source the theme somewhere in `.zshrc`.
```sh
source ~/antsy.zsh-theme
```

#### Configuration
Further customization can be done by setting these enviroment variables in `.zshrc`

```sh
# hideous example
ANTSY_USER_ICON=" %B%F{43}"
ANTSY_USER_COLOR="%B%F{57}"
ANTSY_HOST_COLOR="%B%F{23}"
ANTSY_ROOT_ICON=" %B%F{84}"
ANTSY_ROOT_COLOR="%B%F{74}"
ANTSY_PATH_ICON=" %B%F{136}"
ANTSY_PATH_COLOR="%B%F{130}"
ANTSY_PATH_FORMAT='%47<...<%~%<<% '
ANTSY_GIT_ICON=" %B%F{171}"
ANTSY_GIT_COLOR="%B%F{207}"
ANTSY_GIT_SHA_ICON="|%B%F{54}"
ANTSY_GIT_SHA_COLOR="%B%F{88}"
ANTSY_GIT_STATE_COLOR="%B%F{110}"
ANTSY_JOBS_ICON=" %B%F{41}"
ANTSY_JOBS_COLOR="%B%F{48}"
ANTSY_HISTORY_ICON=" %B%F{99}"
ANTSY_HISTORY_COLOR="%B%F{93}"
ANTSY_TIME_ICON=" %B%F{142}"
ANTSY_TIME_COLOR="%B%F{143}"
ANTSY_VENV_ICON=" %B%F{150}"
ANTSY_VENV_COLOR="%B%F{143}"
ANTSY_VIM_ICON="ﰲ"
ANTSY_VIM_COLOR="%B%F{111}"
ANTSY_VIM_COLOR_ALT="%B%F{90}"
ANTSY_PROMPT_ICON=" "
ANTSY_PROMPT_COLOR="%B%F{137}"
ANTSY_STATUS_ICON="%B%F{35} "
ANTSY_STATUS_COLOR="%B%F{63}"
ANTSY_CONTINUE_ICON="ﲖ "
ANTSY_CONTINUE_COLOR="%B%F{193}"
ANTSY_SELECT_ICON=" "
ANTSY_SELECT_COLOR="%B%F{87}"
ANTSY_MARKER_ICON="─" # U+2500
ANTSY_MARKER_COLOR="%B%F{234}"
```

* `ANTSY_MARKER_ICON` can be multiple characters, with the last character will be repeated to the right side of the terminal.


