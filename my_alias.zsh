alias vim="nvim"
alias v="vim"
alias ls="ls -G"
alias ll="ls -alF"
alias top="top -o cpu"
alias grep="grep --color=auto"
alias gs="git status"
function gpp_run_fun(){
    LONGNAME="lllllllllllnameforgpptempfileafsdsafasdfdasljkl.out"
    JUSTFILE=$TMPDIR/$LONGNAME
    g++ $* -o $JUSTFILE && (./$JUSTFILE; rm -f ./$LONGNAME)
}
alias gpprun="gpp_run_fun"

