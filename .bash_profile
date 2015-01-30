# .bashrc
# vim: fdm=marker
# Update PATH {{{
function chkpath () {
   case ":$PATH:" in
      *":$1:"*) :;; # already in PATH
      *) PATH="$1:$PATH";;
   esac
}
chkpath "$HOME/bin"
chkpath "$HOME/scripts"
# }}}
# Set other environment variables {{{
export LANG=en_US.UTF-8
export PAGER=less
export EDITOR=vim
export VISUAL=vim
#export INPUTRC=~/.inputrc
export MANPAGER=less
export TMPDIR=/tmp
export TMP=/tmp
## }}}
# Aliases {{{
# motd {{{
alias motd=motd_func
# }}}
# ls/ll/lld {{{
#if ! alias ls >/dev/null; then unalias ls; fi # Clear existing alias
case "$OSTYPE" in
   linux*)
      # h: human-readable, l: long, A: show hidden
      alias ls="ls -h --color=auto"
      LSTIMESTYLE='--time-style="+%Y-%m-%d %H:%M:%S"'
      alias ll="LANG=C ls -lA $LSTIMESTYLE --group-directories-first"
      alias lld="ll -d */"
      ;;
   freebsd*)
      alias ll="ls -h -G -lA"                 # long listing format, show hidden
      # TODO: Add directory sorting and ISO time for ls in freebsd
      ;;
esac
# }}}
# :q {{{
alias :q=' exit'
# }}}
# df {{{
alias df='df -h'
# }}}
# nl {{{
alias nl='nl -ba' # Number all lines
# }}}
# tree {{{
alias tree='tree -C' # Show color
# }}}
# }}}
# Set dircolors {{{
if command -v dircolors >/dev/null; then # Check if command exists
   if [ ! -f ~/.dircolors ]; then        # Check if dot file exists
      dircolors -p > ~/.dircolors        # Generate dot file
   fi
   eval $(dircolors -b ~/.dircolors)     # Load into $LS_COLORS
fi
# }}}
# Bash and tty settings {{{
if [ -t 0 -a -t 1 ]; then # Test if interactive terminal. 0:stdin,1:stdout
#  PS1=$'\\[\e[31m\\][\u \w]\$\\[\e[0m\\] '
  PS1=$'[\u \W]\$ '
   stty -ixon  # Disable XON/XOFF flow controll
   stty -ixoff # Disable start/stop characters
   if [ ${BASH_VERSINFO[0]} -ge 4 ]; then
      shopt -s cdspell      # Set autocorrect for cd command
      shopt -s checkwinsize # Set auto $LINES & $COLUMNS updating
      shopt -s cmdhist      # Set multiline to single line saving
      shopt -s dirspell     # Set autocorrect in path (tab completion)
      shopt -s extglob      # Set extended pattern matching
      shopt -s histappend   # Set append to history instead of overwrite
      shopt -s no_empty_cmd_completion
      shopt -u promptvars   # Unset prompt var expansion
      #set -o noclobber     # Prevent accidental clobber with '>'
      #stty -echoctl        # Disable echo for control characters ('^c')
   fi
fi
# }}}
# Less settings {{{
export GROFF_NO_SGR=1
export LESS="FiMQRSX" # Options passed to less
                      #  F: auto exit single page   i: ignore case in search
                      #  M: verbose prompt  R: raw ansi color escapes  Q: quite
                      #  S: don't wrap              X: disable termcap de/init
export LESSHISTFILE="-" # Disable history
#export LESS_TERMCAP_mb=$'\E[01;31m'
#export LESS_TERMCAP_md=$'\E[01;31m'
#export LESS_TERMCAP_me=$'\E[0m'
#export LESS_TERMCAP_so=$'\E[01;44;33m'
#export LESS_TERMCAP_se=$'\E[0m'
#export LESS_TERMCAP_us=$'\E[01;32m'
#export LESS_TERMCAP_ue=$'\E[0m'
# }}}
# Bash history settings {{{
export HISTFILESIZE=16384 # Lines stored on disk
export HISTSIZE=16384     # Lines stored in memory
#export HISTIGNORE="&:[bf]g:exit:ls" # &: Duplicate, bg,fg: job control
export HISTCONTROL=ignoreboth # Ignore spaced and duplicates
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S ' # Add timestamp to history file
# }}}
## Git settings {{{
source /usr/local/share/git-core/contrib/completion/git-completion.bash
source /usr/local/share/git-core/contrib/completion/git-prompt.sh
GIT_PS1_SHOWCOLORHINTS=1
PROMPT_COMMAND='__git_ps1 "[\u \w]" "\\\$ "'
## }}}
# Useful programs {{{
# ncdu: NCurses Disk Usage
# vifm: NCurses file manager
# }}}
# Useful files {{{
# ~/.Xdefaults
# ~/.i3/config
# ~/.bashrc
# ~/.vimrc
# }}}

#script -c "echo -e '\e[0;31mASDF\e[0m'" -q /dev/null
#script -c 'grep EXEC download' -q /dev/null
#script -c 'cal' -q /dev/null
#paste -d' ' <(grep "EXEC" download) <(echo -e '\e[0;31m' 'asdf' '\e[0m')
#tst1=$(script -c 'cal' -q /dev/null); echo "$tst1"
#tst2=$(script -c 'grep EXEC download' -q /dev/null); echo "$tst2"

#read -d'' tst1 script -c "cal" -q /dev/null
function fillCanvas () {
   local linesToFill=$(($LINES - 1))      # Make room for prompt
   local columnsToFill=$(($COLUMNS - 0))
   local fillChar=-1
   local filledLine=$(for ((i=0 ; i < $columnsToFill ; i++)); do
                        if((++fillChar > 9)); then fillChar=0; fi
                        printf "%s" $fillChar;
                      done)
   for ((i=0 ; i < $linesToFill ; i++)); do
      blankCanvas[i]=$(printf "%-s\n" $filledLine);
   done
}
declare -a blankCanvas; fillCanvas # Setup canvas
function drawAt () {
   local x=$1
   local y=$2
   #local blockToDraw="$3"
   #echo "$blockToDraw"
   local newItem=
   mapfile -t newItem < <(script -c 'cal' -q)
   local newItemXlen=${#newItem[@]}
   echo $newItemXlen
   printf "%s\n" "${newItem[@]}"
   local canvasXlen=${#blankCanvas[@]}
   for ((canvasX=0 ; canvasX < $canvasXlen ; canvasX++)); do
      local canvasYlen=${#blankCanvas[canvasX]}
      if((canvasX >= x && canvasX <= (x + newItemXlen))); then
         local newItemYlen=${#newItem[0]}
         echo "newItemYlen: $newItemYlen"
         local linePre="${blankCanvas[canvasX]:0:$y}"
         local lineMid="${newItem[0]}"
         local linePost="${blankCanvas[canvasX]:10:20}"
         local toPrint=$linePre
               toPrint+=$lineMid
               toPrint+="$linePost"
         echo "linePre: $linePre"
         echo "lineMid: $lineMid"
         echo "linePost: $linePost"
         echo "toPrint: $toPrint"
         #blankCanvas[canvasX]=echo "$linePre" "X" "$linePost";
      fi
   done
}
function motd_func () {
drawAt 1 1
printf "%s\n" "${blankCanvas[@]}"
}
#motd
#asdf="012345"; asdf=${asdf/${asdf:3:2}/xx}; echo $asdf
# Autorun {{{
#motd
#clear
#echo "$(blankCanvas)"
#asdf="$(blankCanvas)"
#tst1=$(script -c 'cal' -q /dev/null) #; echo "$tst1" #ALL GLOBBED TOGETHER
#drawAt 1 2 "$tst1"
# }}}











