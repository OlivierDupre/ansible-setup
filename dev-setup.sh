#!/bin/bash
# Base
sudo apt install git git-extras curl vim apt-transport-https ca-certificates software-properties-common build-essential libssl-dev htop tree make libc6-i386 lib32z1 libnss3 libc6  python3 python3-venv  python3-pip  libssl-dev libcurl4-gnutls-dev libexpat1-dev unzip  g++ asciinema gnupg-agent snapd apache2-utils lsb-release gnupg gconf2 pkgconf libnotify4 libxss1 libappindicator1 ncdu dbus-x11 zsh zip

# Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> /home/ubuntu/.profile
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
brew install gcc helm
# GCP
sudo su -
. /etc/os-release
export CLOUD_SDK_REPO="cloud-sdk-$UBUNTU_CODENAME"
nb_definitions=`grep -R cloud-sdk /etc/apt/sources.list.d | wc -l`
if [ $nb_definitions -eq 0 ]; then
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
fi
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - 
# Azure
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
nb_definitions=`grep -R azure-cli /etc/apt/sources.list.d | wc -l`
if [ $nb_definitions -eq 0 ]; then
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $UBUNTU_CODENAME main" | tee /etc/apt/sources.list.d/azure-cli.list
fi
# AWS
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
rm awscliv2.zip
./aws/install
rm -Rf aws
# GCloud
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt update -y && sudo apt -y install google-cloud-sdk google-cloud-sdk-app-engine-java google-cloud-sdk-app-engine-go google-cloud-sdk-bigtable-emulator kubectl
# Misc
# kubeval
if [ ! \( -e /usr/local/bin/kubeval \) ]; then 
    PLATFORM=linux
    wget https://github.com/garethr/kubeval/releases/download/0.14.0/kubeval-${PLATFORM}-amd64.tar.gz;
    tar xf kubeval-${PLATFORM}-amd64.tar.gz;
    mv kubeval /usr/local/bin;
    rm kubeval-${PLATFORM}-amd64.tar.gz;
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
    echo "export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"" >> ~/.zshrc
fi
# kubectx & kubens
sudo su -
if [ ! \( -e /usr/local/bin/kubectx \) || ! \( -e /usr/local/bin/kubectx \) ]; then 
    git clone https://github.com/ahmetb/kubectx /opt/kubectx;
    ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx;
    ln -s /opt/kubectx/kubens /usr/local/bin/kubens;

    COMPDIR=$(pkg-config --variable=completionsdir bash-completion)
    ln -sf /opt/kubectx/completion/kubens.bash $COMPDIR/kubens
    ln -sf /opt/kubectx/completion/kubectx.bash $COMPDIR/kubectx
fi
exit
# dive
sudo su -
nb_definitions=`apt list dive 2> /dev/null | grep install | wc -l`
    if [ $nb_definitions -eq 0 ]; then
    wget https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.deb;
    apt install ./dive_0.9.2_linux_amd64.deb;
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
# SSH
ssh-keygen -C 'dupreolivier@gmail.com'
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
# Fonts
mkdir ~/fonts
cd ~/fonts
git clone --depth 1 git@github.com:ryanoasis/nerd-fonts.git