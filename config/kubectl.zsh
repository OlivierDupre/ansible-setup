#!/bin/zsh

alias docker='docker.exe'
alias docker-compose='docker-compose.exe'
alias kubectl='kubectl.exe'
alias k='kubectl'
alias ki='kubectl --insecure-skip-tls-verify=true'
alias kir='kubectl --insecure-skip-tls-verify=true --field-selector "status.phase==Running"'
alias kctx='kubectx'
alias kns='kubens'

#if [ $commands[kubectl] ]; then source <(kubectl completion zsh); complete -F __start_kubectl k; fi
# Completion files must be accessible in $fpath: https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org
# Look at ~/.oh-my-zsh/completions
complete -F __start_kubectl k

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

function kdash(){
    kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
    echo -e "\n\thttp://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/\n"
    kubectl proxy
}