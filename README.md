# How to
## Play books
`ansible-playbook server.yaml --ask-become-pass `
`ansible-playbook perso.yaml --ask-become-pass `
`ansible-playbook server-removal.yaml --ask-become-pass `

## Get Kube config
`kubectl -n kube-system get cm kubeadm-config -oyaml`