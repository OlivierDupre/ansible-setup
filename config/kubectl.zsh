#!/bin/zsh

alias docker='docker.exe'
alias docker-compose='docker-compose.exe'
# Get container IP by name or ID
alias dip="docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'"
# List all container IPs
alias dipall="docker inspect --format='{{.Name}} {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q)"

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

# Add krew to the path if krew is installed and not already in the path
flag=`echo $PATH|awk '{print match($0,"krew")}'`;
[ -d "$HOME/.krew/bin" ] && if [ $flag -gt 0 ]; then export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"; fi

function kdash(){
    kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
    echo -e "\n\thttp://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/\n"
    kubectl proxy
}
