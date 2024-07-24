#!/bin/bash

WORKDIR="/root/RedTeamToolkit/anon"
GITHUB="https://github.com"

mkdir $WORKDIR

echo "Installing anonymity tools"
apt-get update
apt-get install -y openvpn proxychains wireguard
# Disabled: torsocks

cd $WORKDIR
git clone $GITHUB/SusmithKrishnan/torghost.git && cd torghost && pip3 install -r requirements.txt
cd $WORKDIR
mkdir volana && cd volana
curl -lO -L https://github.com/ariary/volana/releases/latest/download/volana
chmod +x volana
cd $WORKDIR
echo "Done"
