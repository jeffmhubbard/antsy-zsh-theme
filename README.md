# antsy-zsh-theme

Multiline oh-my-zsh theme with git branch and status, virtualenv, exit status, jobs count, and vi-mode indicator.

Intended to be used with a dark, 16-color terminal theme. I use the [Terminal.app or xterm](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors) colors. Tango is okay too.

![screenshot](https://github.com/jeffmhubbard/antsy-zsh-theme/blob/assets/demo.png)

[![asciicast](https://asciinema.org/a/311469.svg)](https://asciinema.org/a/311469)

```sh
# default
ANTSY_HOST_ICON=""
ANTSY_HOST_COLOR="%B%F{green}"
ANTSY_ROOT_ICON=""
ANTSY_ROOT_COLOR="%B%F{red}"
ANTSY_PATH_ICON=""
ANTSY_PATH_COLOR="%B%F{blue}"
ANTSY_PATH_FORMAT="%47<...<%~%<<% "
ANTSY_GIT_ICON=" "
ANTSY_GIT_COLOR="%B%F{red}"
ANTSY_JOBS_ICON=" "
ANTSY_JOBS_COLOR="%B%F{yellow}"
ANTSY_TIME_ICON=""
ANTSY_TIME_COLOR="%B%F{black}"
ANTSY_VENV_ICON=""
ANTSY_VENV_COLOR="%B%F{cyan}"
ANTSY_VIM_ICON="➜"
ANTSY_VIM_COLOR="%B%F{white}"
ANTSY_VIM_COLOR_ALT="%F{cyan}"
ANTSY_PROMPT_ICON="%#"
ANTSY_PROMPT_COLOR="%B%F{white}"
ANTSY_STATUS_ICON="↵"
ANTSY_STATUS_COLOR="%B%F{red}"
ANTSY_CONTINUE_ICON="..."
ANTSY_CONTINUE_COLOR="%B%F{black}"
ANTSY_SELECT_ICON="➜ ?"
ANTSY_SELECT_COLOR="%B%F{white}"
ANTSY_MARKER_ICON="─" # U+2500
ANTSY_MARKER_COLOR="%B%F{black}"
```
