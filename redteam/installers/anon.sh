#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define working directory and GitHub URL
WORKDIR="/root/RedTeamToolkit/anon"
GITHUB="https://github.com"

# Create working directory if it doesn't exist
mkdir -p "$WORKDIR"

echo "Installing anonymity tools"

# Update and install required packages
apt-get update
apt-get install -y openvpn proxychains wireguard build-essential automake libtool

# Define tool URLs and paths
TORGHOST_REPO="$GITHUB/SusmithKrishnan/torghost.git"
VOLANA_URL="https://github.com/ariary/volana/releases/latest/download/volana"
MOONWALK_URL="https://github.com/mufeedvh/moonwalk/releases/download/v1.0.0/moonwalk_linux"
TORSOCKS_REPO="$GITHUB/dgoulet/torsocks.git"
VOLANA_DIR="$WORKDIR/volana"
MOONWALK_DIR="$WORKDIR/moonwalk"
TORSOCKS_DIR="$WORKDIR/torsocks"

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

# Clone torghost repository and install requirements
clone_and_install "$TORGHOST_REPO" "$WORKDIR/torghost"

# Install torsocks from source
if [ ! -d "$TORSOCKS_DIR" ]; then
  git clone "$TORSOCKS_REPO" "$TORSOCKS_DIR"
  cd "$TORSOCKS_DIR"
  ./autogen.sh
  ./configure
  make
  make install
fi

# Download volana and make it executable
mkdir -p "$VOLANA_DIR"
curl -L -o "$VOLANA_DIR/volana" "$VOLANA_URL"
chmod +x "$VOLANA_DIR/volana"

# Download moonwalk and make it executable
mkdir -p "$MOONWALK_DIR"
curl -L -o "$MOONWALK_DIR/moonwalk" "$MOONWALK_URL"
chmod +x "$MOONWALK_DIR/moonwalk"

echo "Done"
