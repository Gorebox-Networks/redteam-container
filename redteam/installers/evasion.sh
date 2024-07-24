#!/bin/bash

set -e

WORKDIR="/root/RedTeamToolkit/evasion"
GITHUB="https://github.com"

# Create working directory if it doesn't exist
mkdir -p "$WORKDIR"

echo "Installing evasion tools"

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

# Clone repositories
clone_repo "$GITHUB/hfiref0x/UACME.git" "$WORKDIR/UACME"
clone_repo "$GITHUB/0xsp-SRD/mortar.git" "$WORKDIR/mortar"
clone_repo "$GITHUB/oddcod3/Phantom-Evasion.git" "$WORKDIR/Phantom-Evasion"

# Setup Phantom-Evasion
if [ -d "$WORKDIR/Phantom-Evasion" ]; then
    cd "$WORKDIR/Phantom-Evasion"
    chmod +x phantom-evasion.py
    python3 phantom-evasion.py --setup
fi

# Add additional evasion tools if necessary
# Example: Clone and setup another evasion tool
# clone_repo "$GITHUB/example/evasion-tool.git" "$WORKDIR/evasion-tool"

echo "Done"
