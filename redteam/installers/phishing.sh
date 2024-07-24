#!/bin/bash

set -e

WORKDIR="/root/RedTeamToolkit/phishing"
GITHUB="https://github.com"

# Create working directory if it doesn't exist
mkdir -p "$WORKDIR"

echo "Installing phishing tools"

# Update and install necessary packages
apt update && apt install -y golang-go

# Function to clone a repository if it doesn't exist
clone_repo() {
    local repo_url=$1
    local target_dir=$2
    if [ ! -d "$target_dir" ]; then
        git clone "$repo_url" "$target_dir"
    else
        echo "Repository $repo_url already cloned in $target_dir"
    fi
}

# Change to working directory
cd "$WORKDIR"

# Clone and setup repositories
clone_repo "$GITHUB/trustedsec/social-engineer-toolkit.git" "$WORKDIR/social-engineer-toolkit"
if [ -d "$WORKDIR/social-engineer-toolkit" ]; then
    cd "$WORKDIR/social-engineer-toolkit"
    pip3 install -r requirements.txt
fi

clone_repo "$GITHUB/L4bF0x/PhishingPretexts.git" "$WORKDIR/PhishingPretexts"
clone_repo "$GITHUB/ryhanson/phishery.git" "$WORKDIR/phishery"
clone_repo "$GITHUB/htr-tech/zphisher.git" "$WORKDIR/zphisher"

clone_repo "$GITHUB/rsmusllp/king-phisher.git" "$WORKDIR/king-phisher"
if [ -d "$WORKDIR/king-phisher" ]; then
    cd "$WORKDIR/king-phisher/tools"
    ./install.sh
fi

clone_repo "$GITHUB/kgretzky/evilginx2.git" "$WORKDIR/evilginx2"
if [ -d "$WORKDIR/evilginx2" ]; then
    cd "$WORKDIR/evilginx2"
    make && make install
fi

clone_repo "$GITHUB/initstring/evil-ssdp.git" "$WORKDIR/evil-ssdp"

# Uncomment to clone and install FiercePhish
# clone_repo "$GITHUB/Raikia/FiercePhish.git" "$WORKDIR/FiercePhish"

clone_repo "$GITHUB/gophish/gophish.git" "$WORKDIR/gophish"
if [ -d "$WORKDIR/gophish" ]; then
    cd "$WORKDIR/gophish"
    go build
fi

clone_repo "$GITHUB/mandiant/ReelPhish.git" "$WORKDIR/ReelPhish"
if [ -d "$WORKDIR/ReelPhish" ]; then
    cd "$WORKDIR/ReelPhish"
    pip3 install -r requirements.txt
fi

clone_repo "$GITHUB/ustayready/CredSniper.git" "$WORKDIR/CredSniper"
if [ -d "$WORKDIR/CredSniper" ]; then
    cd "$WORKDIR/CredSniper"
    pip3 install -r requirements.txt
fi

# Clone and setup cookie-monster
clone_repo "$GITHUB/KingOfTheNOPs/cookie-monster.git" "$WORKDIR/cookie-monster"
if [ -d "$WORKDIR/cookie-monster" ]; then
    cd "$WORKDIR/cookie-monster"
    pip3 install -r requirements.txt
fi

echo "Done"
