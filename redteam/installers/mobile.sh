#!/bin/bash

set -e

WORKDIR="/root/RedTeamToolkit/mobile"
GITHUB="https://github.com"

# Create working directory if it doesn't exist
mkdir -p "$WORKDIR"

echo "Installing mobile tools"

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

# Clone Mobile Security Framework (MobSF) and install dependencies
clone_repo "$GITHUB/MobSF/Mobile-Security-Framework-MobSF.git" "$WORKDIR/Mobile-Security-Framework-MobSF"
if [ -d "$WORKDIR/Mobile-Security-Framework-MobSF" ]; then
    cd "$WORKDIR/Mobile-Security-Framework-MobSF"
    ./setup.sh
    # Alternatively, if there's a specific installation command for MobSF:
    # pip3 install -r requirements.txt
fi

# Clone APKLeaks and install dependencies
clone_repo "$GITHUB/dwisiswant0/apkleaks.git" "$WORKDIR/apkleaks"
if [ -d "$WORKDIR/apkleaks" ]; then
    cd "$WORKDIR/apkleaks"
    pip3 install -r requirements.txt
fi

echo "Done"
