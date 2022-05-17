alias vim="nvim"
alias v="vim"
alias ls="lsd --icon never"
alias ll="ls -alF"
alias top="top -o cpu"
alias grep="grep --color=auto"

alias g="git"
alias gs="git status"
alias ga="git add"
alias gl="git log"
alias gd="git diff"
alias gc="git checkout"
alias gm="git commit"

function gpp_run_fun(){
    LONGNAME="lllllllllllnameforgpptempfileafsdsafasdfdasljkl.out"
    JUSTFILE=$TMPDIR/$LONGNAME
    g++ $* -o $JUSTFILE && (./$JUSTFILE; rm -f ./$LONGNAME)
}
alias gpprun="gpp_run_fun"
# alias tmux="env TERM=xterm-256color tmux"
alias zshp="MYZSH_DO_PROFILING=true zsh"
