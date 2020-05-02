#!/bin/bash
# Base
sudo apt install git git-extras curl vim apt-transport-https ca-certificates software-properties-common build-essential libssl-dev htop tree make libc6-i386 lib32z1 libnss3 libc6  python3 python3-venv  python3-pip  libssl-dev libcurl4-gnutls-dev libexpat1-dev unzip  g++ asciinema gnupg-agent snapd apache2-utils lsb-release gnupg gconf2 pkgconf libnotify4 libxss1 libappindicator1 ncdu dbus-x11 zsh zip jq ruby-dev

# SSH
ssh-keygen  -t rsa -b 4096 -C 'dupreolivier@gmail.com'
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# Fonts
mkdir ~/fonts
cd ~/fonts
git clone --depth 1 git@github.com:ryanoasis/nerd-fonts.git
nerd-fonts/install.sh

# zsh
sudo chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp ~/.zshrc ~/.zshrc.$(date +%Y-%m-%d)
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
nb_definitions=`grep -R powerlevel10k ~/.zshrc | wc -l`
if [ $nb_definitions -eq 0 ]; then
    sed -i 's/ZSH_THEME/\#ZSH_THEME/g'  ~/.zshrc
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
fi
#p10k configure
exec zsh

# Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> /home/$USER/.zshrc
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
brew install gcc helm

# GCP
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-sdk kubectl
# sudo apt -y install  google-cloud-sdk-app-engine-java google-cloud-sdk-app-engine-go google-cloud-sdk-bigtable-emulator 
COMPDIR='~/.oh-my-zsh/completions'
mkdir -p $COMPDIR
kubectl completion zsh > $COMPDIR/_kubectl
# kubectx & kubens --> Manual download beta version from https://github.com/ahmetb/kubectx/releases/tag/v0.9.0
# sudo su -
# if [ ! \( -e /usr/local/bin/kubectx \) || ! \( -e /usr/local/bin/kubectx \) ]; then 
#     git clone https://github.com/ahmetb/kubectx /opt/kubectx;
#     ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx;
#     ln -s /opt/kubectx/kubens /usr/local/bin/kubens;

    
#     ln -sf /opt/kubectx/completion/kubens.bash $COMPDIR/_kubens
#     ln -sf /opt/kubectx/completion/kubectx.bash $COMPDIR/_kubectx
# fi
# exit

# Azure
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
##### OR #####
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
# AZ_REPO=$(lsb_release -cs)
AZ_REPO=eoan
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list

# curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo  tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
# nb_definitions=`grep -R azure-cli /etc/apt/sources.list.d | wc -l`
# if [ $nb_definitions -eq 0 ]; then
#     echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $UBUNTU_CODENAME main" | tee /etc/apt/sources.list.d/azure-cli.list
# fi

# AWS
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
rm awscliv2.zip
./aws/install
rm -Rf aws
## Serverless
curl -o- -L https://slss.io/install | bash

# Misc
# kubeval
if [ ! \( -e /usr/local/bin/kubeval \) ]; then 
    PLATFORM=linux
    mkdir ~/kubeval
    curl -SL https://github.com/garethr/kubeval/releases/download/0.15.0/kubeval-$PLATFORM-amd64.tar.gz  | tar -xz -C ~/kubeval
    sudo mv ~/kubeval/kubeval /usr/local/bin
    rm -Rf ~/kubeval
fi

# krew
# https://krew.sigs.k8s.io/docs/user-guide/setup/install/
(
  set -x; cd "$(mktemp -d)" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.{tar.gz,yaml}" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" &&
  "$KREW" install --manifest=krew.yaml --archive=krew.tar.gz &&
  "$KREW" update
)
nb_definitions=`grep -R krew ~/.zshrc | wc -l`
if [ $nb_definitions -eq 0 ]; then
    echo "export PATH="${KREW_ROOT:-$HOME/.krew}/bin:\$PATH"" >> ~/.zshrc
fi

# dive
nb_definitions=`apt list dive 2> /dev/null | grep install | wc -l`
if [ $nb_definitions -eq 0 ]; then
    curl -SL https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.deb -o dive_0.9.2_linux_amd64.deb
    dpkg -i ./dive_0.9.2_linux_amd64.deb;
    rm ./dive_0.9.2_linux_amd64.deb
fi
exit

# SDKMan
curl -s "https://get.sdkman.io" | bash
exec zsh
sdk install java && sdk install kotlin && sdk install maven && sdk install gradle && sdk install springboot

# NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
exec zsh
nvm install node

# Go
GO_VERSION=1.14.2.linux-amd64
sudo curl -SL https://dl.google.com/go/go$GO_VERSION.tar.gz | sudo tar -C /usr/local -xzf
nb_definitions=`grep -R /usr/local/go ~/.zshrc | wc -l`
if [ $nb_definitions -eq 0 ]; then
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
fi

# eg
sudo ln -s /usr/bin/python3 /usr/bin/python
sudo git clone https://github.com/srsudar/eg /opt/eg;
sudo ln -s /opt/eg/eg_exec.py /usr/local/bin/eg;

# colorls
sudo gem install colorls
