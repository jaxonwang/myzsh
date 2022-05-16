# use vim emulator
bindkey -v

BASEDIR=$(dirname "$0")

# init brew and auto complete
if [[ $(uname) == "Darwin" ]]; then
    source $BASEDIR/darwin.zsh
fi

# locale
export LC_ALL="en_US.UTF-8"

# prompt
export PS1="%n@%m %~ %(?..[%?] )%# "

# editor
export VISUAL="vim"
export EDITOR="$VISUAL"

# term color
export TERM="xterm-256color"
export tCLICOLOR='Yes'

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

autoload -Uz compinit
compinit

# plugins
#
# fzf-tab needs to be loaded after compinit, but before plugins which will wrap
# widgets, such as zsh-autosuggestions or fast-syntax-highlighting!!
source $BASEDIR/fzf-tab/fzf-tab.plugin.zsh
source $BASEDIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $BASEDIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $BASEDIR/zsh-completions/zsh-completions.plugin.zsh
source $BASEDIR/zsh-autopair/autopair.zsh && autopair-init

# fzf
export FZF_DEFAULT_COMMAND='fd'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d'

# z
eval "$(zoxide init zsh)"

# color man page
export LESS_TERMCAP_mb=$'\E[1m\E[32m'
export LESS_TERMCAP_mh=$'\E[2m'
export LESS_TERMCAP_mr=$'\E[7m'
export LESS_TERMCAP_md=$'\E[1m\E[36m'
export LESS_TERMCAP_ZW=""
export LESS_TERMCAP_us=$'\E[4m\E[1m\E[37m'
export LESS_TERMCAP_me=$'\E(B\E[m'
export LESS_TERMCAP_ue=$'\E[24m\E(B\E[m'
export LESS_TERMCAP_ZO=""
export LESS_TERMCAP_ZN=""
export LESS_TERMCAP_se=$'\E[27m\E(B\E[m'
export LESS_TERMCAP_ZV=""
export LESS_TERMCAP_so=$'\E[1m\E[33m\E[44m'
export GROFF_NO_SGR=1         # For Konsole and Gnome-terminal

# alias
source $BASEDIR/my_alias.zsh
