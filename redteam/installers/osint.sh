#!/bin/bash

set -e

WORKDIR="/root/RedTeamToolkit/osint"
GITHUB="https://github.com"

# Create working directory if it doesn't exist
mkdir -p "$WORKDIR"

echo "Installing OSINT/Recon tools"

# Update and install necessary packages
apt update && apt install -y \
    libncurses5 \
    libxml2 \
    tcpdump \
    libexiv2-dev \
    libmariadb3 \
    libmariadb-dev \
    libmariadb-dev-compat \
    tor \
    cmake \
    libboost-all-dev

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
clone_repo "$GITHUB/cbk914/SecLists.git" "$WORKDIR/SecLists"
clone_repo "$GITHUB/0xinfection/tidos-framework.git" "$WORKDIR/tidos-framework"
if [ -d "$WORKDIR/tidos-framework" ]; then
    cd "$WORKDIR/tidos-framework"
    pip3 install -r requirements.txt
fi

clone_repo "$GITHUB/xadhrit/terra.git" "$WORKDIR/terra"
if [ -d "$WORKDIR/terra" ]; then
    cd "$WORKDIR/terra"
    pip3 install -r requirements.txt
fi

clone_repo "$GITHUB/twintproject/twint.git" "$WORKDIR/twint"
if [ -d "$WORKDIR/twint" ]; then
    cd "$WORKDIR/twint"
    pip3 install -r requirements.txt
fi

clone_repo "$GITHUB/sundowndev/phoneinfoga.git" "$WORKDIR/phoneinfoga"
clone_repo "$GITHUB/sham00n/buster.git" "$WORKDIR/buster"
if [ -d "$WORKDIR/buster" ]; then
    cd "$WORKDIR/buster"
    python3 setup.py install
fi

clone_repo "$GITHUB/thewhiteh4t/pwnedOrNot.git" "$WORKDIR/pwnedOrNot"
if [ -d "$WORKDIR/pwnedOrNot" ]; then
    cd "$WORKDIR/pwnedOrNot"
    ./install.sh
fi

clone_repo "$GITHUB/laramies/theHarvester.git" "$WORKDIR/theHarvester"
if [ -d "$WORKDIR/theHarvester" ]; then
    cd "$WORKDIR/theHarvester"
    pip3 install -r requirements.txt
fi

clone_repo "$GITHUB/laramies/metagoofil.git" "$WORKDIR/metagoofil"
clone_repo "$GITHUB/lanmaster53/recon-ng.git" "$WORKDIR/recon-ng"
if [ -d "$WORKDIR/recon-ng" ]; then
    cd "$WORKDIR/recon-ng"
    pip3 install -r REQUIREMENTS
fi

clone_repo "$GITHUB/xillwillx/skiptracer.git" "$WORKDIR/skiptracer"
if [ -d "$WORKDIR/skiptracer" ]; then
    cd "$WORKDIR/skiptracer"
    pip3 install -r requirements.txt
fi

clone_repo "$GITHUB/FortyNorthSecurity/Just-Metadata.git" "$WORKDIR/Just-Metadata"
clone_repo "$GITHUB/smicallef/spiderfoot.git" "$WORKDIR/spiderfoot"
if [ -d "$WORKDIR/spiderfoot" ]; then
    cd "$WORKDIR/spiderfoot"
    pip3 install -r requirements.txt
fi

clone_repo "$GITHUB/thewhiteh4t/FinalRecon.git" "$WORKDIR/FinalRecon"
if [ -d "$WORKDIR/FinalRecon" ]; then
    cd "$WORKDIR/FinalRecon"
    pip3 install -r requirements.txt
fi

clone_repo "$GITHUB/21y4d/nmapAutomator.git" "$WORKDIR/nmapAutomator"
clone_repo "$GITHUB/Datalux/Osintgram.git" "$WORKDIR/Osintgram"
if [ -d "$WORKDIR/Osintgram" ]; then
    cd "$WORKDIR/Osintgram"
    pip3 install -r requirements.txt
fi

clone_repo "$GITHUB/Greenwolf/social_mapper.git" "$WORKDIR/social_mapper"
if [ -d "$WORKDIR/social_mapper" ]; then
    cd "$WORKDIR/social_mapper"
    pip3 install -r requirements.txt
fi

clone_repo "$GITHUB/m8r0wn/CrossLinked.git" "$WORKDIR/CrossLinked"
if [ -d "$WORKDIR/CrossLinked" ]; then
    cd "$WORKDIR/CrossLinked"
    pip3 install -r requirements.txt
fi

clone_repo "$GITHUB/sense-of-security/ADRecon.git" "$WORKDIR/ADRecon"
clone_repo "$GITHUB/maldevel/EmailHarvester.git" "$WORKDIR/EmailHarvester"
if [ -d "$WORKDIR/EmailHarvester" ]; then
    cd "$WORKDIR/EmailHarvester"
    pip3 install -r requirements.txt
fi

# Uncomment to clone and install tinfoleak
# clone_repo "$GITHUB/vaguileradiaz/tinfoleak.git" "$WORKDIR/tinfoleak"

echo "Done"
