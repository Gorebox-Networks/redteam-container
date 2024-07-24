#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

WORKDIR="/root/RedTeamToolkit/wireless"
GITHUB="https://github.com"

mkdir -p $WORKDIR

echo "Installing wireless tools"

# Update and install aircrack-ng
apt-get update -y && apt-get install -y aircrack-ng

# Clone and install wifiCrack
cd $WORKDIR
git clone $GITHUB/s4vitar/wifiCrack.git && cd wifiCrack
chmod +x install.sh && ./install.sh

# Clone and install wifite
cd $WORKDIR
git clone $GITHUB/derv82/wifite2.git && cd wifite2
python3 setup.py install

# Clone and install wifiphisher
cd $WORKDIR
git clone $GITHUB/wifiphisher/wifiphisher.git && cd wifiphisher
python3 setup.py install

# Cleanup
cd $WORKDIR
echo "Done"
