#!/bin/bash

set -e

WORKDIR="/root/RedTeamToolkit/c2"
GITHUB="https://github.com"

# Create working directory if it doesn't exist
mkdir -p "$WORKDIR"

echo "Installing C2 tools"

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

# Install dependencies
apt update && apt install -y golang build-essential wget unzip

# Install Sliver
# Using one-liner installation
curl https://sliver.sh/install | sudo bash

# Alternative: Compile from source
# Uncomment the following lines if you prefer to compile from source
# git clone https://github.com/BishopFox/sliver.git
# cd sliver
# make build

# Clone and setup AM0N-Eye
clone_repo "$GITHUB/cbk914/AM0N-Eye.git" "$WORKDIR/AM0N-Eye"
if [ -d "$WORKDIR/AM0N-Eye" ]; then
    cd "$WORKDIR/AM0N-Eye"
    unzip AM0N-Eye.zip -d AM0N-Eye
    cd AM0N-Eye
    ./setup.sh
fi

echo "Done"
