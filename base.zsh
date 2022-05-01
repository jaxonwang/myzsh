# use vim emulator

bindkey -v

# locale
export LC_ALL="en_US.UTF-8"

# prompt
export PS1="%n@%m %~ %# "

# editor
export VISUAL="vim"
export EDITOR="$VISUAL"

# term color
export TERM="xterm-256color"
export tCLICOLOR='Yes'

# plugins
source ./zsh-autosuggestions/zsh-autosuggestions.zsh
source ./fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ./zsh-completions/zsh-completions.plugin.zsh
source ./zsh-z/zsh-z.plugin.zsh

