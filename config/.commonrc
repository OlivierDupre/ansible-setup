#!/bin/zsh

export VISUAL=vim
export EDITOR="$VISUAL"

# Upgrades the distribution (soft and kernel, not Ubuntu itself) then removes and cleans unecessary packages.
alias distUpgrade='sudo apt update && sudo apt full-upgrade && sudo apt autoclean && sudo apt autoremove'
alias vi="vim"
alias diff="colordiff"
alias mkdir="mkdir -p"

alias ls="ls --color=always"
alias ll="ls -alhF"

alias ds="du . -d 1 -ah|sort -rh"
alias ducks='du -chs *|sort -rn|head -11'
alias treeSize="tree -dhs --du"

alias ap='ansible-playbook'
alias apb='ansible-playbook --ask-become-pass'

alias openports='sudo netstat -vtlnp --listening -4'
alias ps-mem='ps -o time,ppid,pid,nice,pcpu,pmem,user,comm -A | sort -n -k 6 | tail -15'
alias myip='curl ip.appspot.com'
alias open='xdg-open'
alias woman='eg'

# Récupération des sources et javadocs Maven
alias mvnSourcesAndDocs="mvn clean install dependency:sources dependency:resolve -Dclassifier=javadoc"

alias goIndexedDb="cd ~/.mozilla/firefox/*.default/storage/permanent/"

# Add tab completion for SSH hostnames based on ~/.ssh/config
# ignoring wildcards
[[ -e "$HOME/.ssh/config" ]] && complete -o "default" \
	-o "nospace" \
	-W "$(grep "^Host" ~/.ssh/config | \
	grep -v "[?*]" | cut -d " " -f2 | \
	tr ' ' '\n')" scp sftp ssh

fkill9(){
    ps aux | grep "$1" | grep -v grep | awk '{print $2;}' | while read p; do kill -9 $p; done
}

extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

function ssh-tmux() { 
	ssh $* -t tmux a || ssh $* -t tmux; 
}

# Strip leading white space (new line inclusive).
ltrim(){
    [[ "$1" =~ [^[:space:]].* ]]
    printf "%s" "$BASH_REMATCH"
}

# Strip trailing white space (new line inclusive).
rtrim(){
    [[ "$1" =~ .*[^[:space:]] ]]
    printf "%s" "$BASH_REMATCH"
}

# Strip leading and trailing white space (new line inclusive).
trim(){
    # printf "%s" "$(rtrim "$(ltrim "$1")")"
    echo "$1" | xargs
}