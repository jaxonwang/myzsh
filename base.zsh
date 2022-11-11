if [[ ${MYZSH_DO_PROFILING} == true ]]; then
    zmodload zsh/zprof
fi

# use vim emulator
bindkey -v

# https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel
MY_DOTFILE_REPO_PATH=$( cd -- "$( dirname -- "$0" )" &> /dev/null && pwd )
export MY_DOTFILE_REPO_PATH

# init brew and auto complete
if [[ $(uname) == "Darwin" ]]; then
    source $MY_DOTFILE_REPO_PATH/darwin.zsh
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

autoload -Uz compinit
compinit
# speed up compinit by compilation
# Execute code in the background to not affect the current session
{
  # Compile zcompdump, if modified, to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# plugins
source $MY_DOTFILE_REPO_PATH/zsh-autosuggestions/zsh-autosuggestions.zsh
source $MY_DOTFILE_REPO_PATH/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $MY_DOTFILE_REPO_PATH/zsh-completions/zsh-completions.plugin.zsh
source $MY_DOTFILE_REPO_PATH/zsh-autopair/autopair.zsh

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
source $MY_DOTFILE_REPO_PATH/my_alias.zsh

if [[ ${MYZSH_DO_PROFILING} == true ]]; then
    zprof
    exit
fi

append_path(){
    local newpath=$1
    if [[ ! -d $newpath ]]; then
        printf "warnning: path $newpath does not exist\n"
        return
    fi
    # affix colons on either side of $PATH to simplify matching
    case ":${PATH}:" in
        *:"$newpath":*)
            ;;
        *)
            export PATH="$newpath:$PATH"
            ;;
    esac
}

# locally set up using my personal author info
dolocalgitconfig(){
    git config --local user.email "jxwang92@gmail.com"
    git config --local user.name "JX Wang"
    git config --local --get user.name
    git config --local --get user.email
}
alias gitlocalsetup='dolocalgitconfig'

giturl(){
    url=$(git remote get-url origin)
    if [[ $? -ne 0 ]]; then
        return $?
    fi

   if [[ $url != "git@"* ]]; then
        IFS='/' read -r -A a <<< $url
        sshurl="git@${a[3]}:${a[4]}/${a[5]}"
        git remote set-url origin $sshurl
   fi
}
