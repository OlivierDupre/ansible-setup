# How to
## Play books
`ansible-playbook server.yaml --ask-become-pass `
`ansible-playbook perso.yaml --ask-become-pass `
`ansible-playbook server-removal.yaml --ask-become-pass `

## Get Kube config
`kubectl -n kube-system get cm kubeadm-config -oyaml`

## Display Dashboard
* Generate token with:
  * `kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')`
* Proxy the Dashboard:
  * `kubectl proxy`
* Login to the Dashboard:
  * `http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/`