#!/bin/bash

set -e

WORKDIR="/root/RedTeamToolkit/vulnscan"
GITHUB="https://github.com"

# Create working directory if it doesn't exist
mkdir -p "$WORKDIR"

echo "Installing vulnerability scan tools"

# Update and install necessary packages
apt update && apt install -y libsasl2-dev libldap2-dev golang-go

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
clone_repo "$GITHUB/SecureAuthCorp/impacket.git" "$WORKDIR/impacket"
if [ -d "$WORKDIR/impacket" ]; then
    cd "$WORKDIR/impacket"
    python3 -m pip install .
fi

clone_repo "$GITHUB/darkarnium/Log4j-CVE-Detect.git" "$WORKDIR/Log4j-CVE-Detect"
clone_repo "$GITHUB/chenjj/espoofer.git" "$WORKDIR/espoofer"
if [ -d "$WORKDIR/espoofer" ]; then
    cd "$WORKDIR/espoofer"
    pip3 install -r requirements.txt
fi

clone_repo "$GITHUB/GlobalCyberAlliance/DomainSecurityScanner.git" "$WORKDIR/DomainSecurityScanner"
if [ -d "$WORKDIR/DomainSecurityScanner" ]; then
    cd "$WORKDIR/DomainSecurityScanner"
    make
fi

clone_repo "$GITHUB/vavkamil/dkimsc4n.git" "$WORKDIR/dkimsc4n"
if [ -d "$WORKDIR/dkimsc4n" ]; then
    cd "$WORKDIR/dkimsc4n"
    pip3 install -r requirements.txt
fi

clone_repo "$GITHUB/drwetter/testssl.sh.git" "$WORKDIR/testssl.sh"
clone_repo "$GITHUB/e1abrador/SpringCorePoC.sh.git" "$WORKDIR/SpringCorePoC"

# Install nuclei
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
nuclei -ut

echo "Done"
