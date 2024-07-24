#!/bin/bash

set -e

WORKDIR="/root/RedTeamToolkit/weapons"
GITHUB="https://github.com"

# Create working directory if it doesn't exist
mkdir -p "$WORKDIR"

echo "Installing digital weapon factory"

# Update and install necessary packages
apt update && apt install -y backdoor-factory

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
clone_repo "$GITHUB/WyAtu/CVE-2018-20250.git" "$WORKDIR/CVE-2018-20250"
clone_repo "$GITHUB/bhdresh/CVE-2017-8759.git" "$WORKDIR/CVE-2017-8759"
clone_repo "$GITHUB/bhdresh/CVE-2017-0199.git" "$WORKDIR/CVE-2017-0199"
clone_repo "$GITHUB/rxwx/CVE-2017-8570.git" "$WORKDIR/CVE-2017-8570"

clone_repo "$GITHUB/koutto/jok3r.git" "$WORKDIR/jok3r"
if [ -d "$WORKDIR/jok3r" ]; then
    cd "$WORKDIR/jok3r"
    chmod +x install-all.sh
    ./install-all.sh
fi

clone_repo "$GITHUB/nccgroup/demiguise.git" "$WORKDIR/demiguise"
clone_repo "$GITHUB/Mr-Un1k0d3r/MaliciousMacroGenerator.git" "$WORKDIR/MaliciousMacroGenerator"

clone_repo "$GITHUB/Mr-Un1k0d3r/DKMC.git" "$WORKDIR/DKMC"
if [ -d "$WORKDIR/DKMC" ]; then
    cd "$WORKDIR/DKMC"
    mkdir -p output
fi

clone_repo "$GITHUB/0xdeadbeefJERKY/Office-DDE-Payloads.git" "$WORKDIR/Office-DDE-Payloads"
if [ -d "$WORKDIR/Office-DDE-Payloads" ]; then
    cd "$WORKDIR/Office-DDE-Payloads"
    pip3 install -r requirements.txt
fi

clone_repo "$GITHUB/joker25000/DZGEN.git" "$WORKDIR/DZGEN"
if [ -d "$WORKDIR/DZGEN" ]; then
    cd "$WORKDIR/DZGEN"
    chmod +x DZGEN
fi

clone_repo "$GITHUB/Arno0x/EmbedInHTML.git" "$WORKDIR/EmbedInHTML"
clone_repo "$GITHUB/sevagas/macro_pack.git" "$WORKDIR/macro_pack"
if [ -d "$WORKDIR/macro_pack" ]; then
    cd "$WORKDIR/macro_pack"
    pip3 install -r requirements.txt
fi

clone_repo "$GITHUB/snovvcrash/DInjector.git" "$WORKDIR/DInjector"
clone_repo "$GITHUB/trustedsec/unicorn.git" "$WORKDIR/unicorn"

# Uncomment to clone the backdoor factory from secretsquirrel
# clone_repo "$GITHUB/secretsquirrel/the-backdoor-factory.git" "$WORKDIR/the-backdoor-factory"

clone_repo "$GITHUB/enigma0x3/Generate-Macro.git" "$WORKDIR/Generate-Macro"
clone_repo "$GITHUB/infosecn1nja/MaliciousMacroMSBuild.git" "$WORKDIR/MaliciousMacroMSBuild"

clone_repo "$GITHUB/FSecureLABS/wePWNise.git" "$WORKDIR/wePWNise"
if [ -d "$WORKDIR/wePWNise" ]; then
    pip3 install termcolor
fi

clone_repo "$GITHUB/r00t-3xp10it/trojanizer.git" "$WORKDIR/trojanizer"
if [ -d "$WORKDIR/trojanizer" ]; then
    cd "$WORKDIR/trojanizer"
    chmod +x *.sh
fi

clone_repo "$GITHUB/khr0x40sh/MacroShop.git" "$WORKDIR/MacroShop"
clone_repo "$GITHUB/outflanknl/EvilClippy.git" "$WORKDIR/EvilClippy"

clone_repo "$GITHUB/TheWover/donut.git" "$WORKDIR/donut"
if [ -d "$WORKDIR/donut" ]; then
    cd "$WORKDIR/donut"
    make
fi

clone_repo "$GITHUB/DanMcInerney/icebreaker.git" "$WORKDIR/icebreaker"
if [ -d "$WORKDIR/icebreaker" ]; then
    cd "$WORKDIR/icebreaker"
    chmod +x setup.sh
    ./setup.sh
    pipenv install --three
fi

clone_repo "$GITHUB/infobyte/evilgrade.git" "$WORKDIR/evilgrade"
clone_repo "$GITHUB/mindcrypt/powerglot.git" "$WORKDIR/powerglot"

echo "Done"
