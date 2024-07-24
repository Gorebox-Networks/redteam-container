#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define working directory and GitHub URL
WORKDIR="/root/RedTeamToolkit/activedirectory"
GITHUB="https://github.com"

# Create working directory if it doesn't exist
mkdir -p "$WORKDIR"

echo "Installing AD tools"

# Update and install required packages
apt-get update
apt-get install -y bloodhound golang-go pipenv docker.io --fix-missing

# Start Docker service if not running
systemctl start docker
systemctl enable docker

# Install Python packages
pip3 install ldap3 dnspython future ldapdomaindump kerberoast

# Define repositories and directories
ADENUM_REPO="$GITHUB/SecuProject/ADenum.git"
ADALANCHE_REPO="$GITHUB/lkarlslund/Adalanche.git"
ICEBREAKER_REPO="$GITHUB/DanMcInerney/icebreaker.git"
ADENUM_DIR="$WORKDIR/ADenum"
ADALANCHE_DIR="$WORKDIR/Adalanche"
ICEBREAKER_DIR="$WORKDIR/icebreaker"

# Function to clone git repo and install requirements
clone_and_install() {
  local repo_url=$1
  local target_dir=$2
  if [ ! -d "$target_dir" ]; then
    git clone "$repo_url" "$target_dir"
    cd "$target_dir"
    if [ -f "requirements.txt" ]; then
      pip3 install -r requirements.txt
    fi
  fi
}

# Clone ADenum repository and install requirements
clone_and_install "$ADENUM_REPO" "$ADENUM_DIR"

# Build Adalanche using Docker
if [ ! -d "$ADALANCHE_DIR" ]; then
  git clone "$ADALANCHE_REPO" "$ADALANCHE_DIR"
  cd "$ADALANCHE_DIR"
  docker run --rm -v "$(pwd)":/workspace -w /workspace mcr.microsoft.com/powershell pwsh ./build.ps1
fi

# Setup icebreaker
if [ ! -d "$ICEBREAKER_DIR" ]; then
  git clone "$ICEBREAKER_REPO" "$ICEBREAKER_DIR"
  cd "$ICEBREAKER_DIR"
  ./setup.sh
  pipenv install --three
  pipenv shell
fi

echo "Done"
