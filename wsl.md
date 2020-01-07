# Windows Subsystem for Linux

## Use Docker

### Source

https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly

### Code

``` bash
# Update the apt package list.
sudo apt update -y

# Install Docker's package dependencies.
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Clean things up
sudo apt autoremove -y
sudo apt autoclean -y

# Download and add Docker's official public PGP key.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify the fingerprint.
sudo apt-key fingerprint 0EBFCD88

# Add the `stable` channel's Docker upstream repository.
#
# If you want to live on the edge, you can change "stable" below to "test" or
# "nightly". I highly recommend sticking with stable!
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update the apt package list (for the new apt repo).
sudo apt update -y

# Install the latest version of Docker CE.
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Allow your user to access the Docker CLI without needing root access.
sudo usermod -aG docker $USER
```

## Homebrew --Useful?

### Source

https://brew.sh/index_fr
https://docs.brew.sh/Homebrew-on-Linux

### Code

``` bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.bashrc

sudo apt install -y build-essential curl file git
```
