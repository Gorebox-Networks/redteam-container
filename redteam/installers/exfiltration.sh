#!/bin/bash

set -e

WORKDIR="/root/RedTeamToolkit/exfiltration"
GITHUB="https://github.com"

# Create working directory if it doesn't exist
mkdir -p "$WORKDIR"

echo "Installing exfiltration tools"

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

# Clone and install Mistica
clone_repo "$GITHUB/IncideDigital/Mistica.git" "$WORKDIR/Mistica"
if [ -d "$WORKDIR/Mistica" ]; then
    cd "$WORKDIR/Mistica"
    pip3 install dnslib
fi

# Clone and install dnscat2
clone_repo "$GITHUB/iagox86/dnscat2.git" "$WORKDIR/dnscat2"

# Clone and install DNSExfiltrator
clone_repo "$GITHUB/Arno0x/DNSExfiltrator.git" "$WORKDIR/DNSExfiltrator"
if [ -d "$WORKDIR/DNSExfiltrator" ]; then
    cd "$WORKDIR/DNSExfiltrator"
    pip3 install -r requirements.txt
fi

# Clone and install Egress-Assess
clone_repo "$GITHUB/FortyNorthSecurity/Egress-Assess.git" "$WORKDIR/Egress-Assess"
if [ -d "$WORKDIR/Egress-Assess" ]; then
    cd "$WORKDIR/Egress-Assess"
    pip3 install pyftpdlib
    openssl req -new -x509 -keyout server.pem -out server.pem -days 365 -nodes
fi

# Clone and install DET
clone_repo "$GITHUB/PaulSec/DET.git" "$WORKDIR/DET"
if [ -d "$WORKDIR/DET" ]; then
    cd "$WORKDIR/DET"
    pip3 install -r requirements.txt
fi

# Clone Powershell-RAT
clone_repo "$GITHUB/Viralmaniar/Powershell-RAT.git" "$WORKDIR/Powershell-RAT"

# Clone Tunna
clone_repo "$GITHUB/SECFORCE/Tunna.git" "$WORKDIR/Tunna"

# Clone and install PyExfil
clone_repo "$GITHUB/ytisf/PyExfil.git" "$WORKDIR/PyExfil"
if [ -d "$WORKDIR/PyExfil" ]; then
    cd "$WORKDIR/PyExfil"
    pip3 install -r requirements3.txt
fi

echo "Done"
