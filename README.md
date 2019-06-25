# How to
## Play books
`ansible-playbook server.yaml --ask-become-pass `
`ansible-playbook perso.yaml --ask-become-pass `
`ansible-playbook server-removal.yaml --ask-become-pass `

## Get Kube config
`kubectl -n kube-system get cm kubeadm-config -oyaml`

## Display K8S Dashboard
* Generate token with:
  * `kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')`
* Proxy the Dashboard:
  * `kubectl proxy`
* Login to the Dashboard:
  * `http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/`

## Update Docker config
* Patch `/var/snap/microk8s/current/args/docker-daemon.json`
* Run `sudo systemctl restart snap.microk8s.daemon-docker.service && sudo  systemctl status snap.microk8s.daemon-docker.service` 
  * or `sudo systemctl daemon-reload && sudo systemctl restart docker`

## Use default Docker nvidia runtime
* `docker run --rm  -it  ubuntu  dmesg`
* `docker run --rm  -it  ubuntu  uname -a`

## Use gVisor
* `docker run --rm --runtime=runsc -it  ubuntu  dmesg`
* `docker run --rm --runtime=runsc -it  ubuntu  uname -a`

## Use kata-container
* `docker run --rm --runtime=kata-container -it  ubuntu  dmesg`
* `docker run --rm --runtime=kata-container -it  ubuntu  uname -a`