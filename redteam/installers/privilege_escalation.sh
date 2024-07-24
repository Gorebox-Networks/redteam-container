#!/bin/bash

set -e

WORKDIR="/root/RedTeamToolkit/privesc"
GITHUB="https://github.com"

# Create working directory if it doesn't exist
mkdir -p "$WORKDIR"

echo "Installing privilege escalation tools"

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
clone_repo "$GITHUB/AlessandroZ/BeRoot.git" "$WORKDIR/BeRoot"
clone_repo "$GITHUB/rebootuser/LinEnum.git" "$WORKDIR/LinEnum"
clone_repo "$GITHUB/InteliSecureLabs/Linux_exploit_Suggester.git" "$WORKDIR/Linux_exploit_Suggester"
# Uncomment to clone linuxprivchecker
# clone_repo "$GITHUB/sleventyeleven/linuxprivchecker.git" "$WORKDIR/linuxprivchecker"
pip3 install linuxprivchecker

clone_repo "$GITHUB/diego-treitos/linux-smart-enumeration.git" "$WORKDIR/linux-smart-enumeration"
if [ -d "$WORKDIR/linux-smart-enumeration" ]; then
    cd "$WORKDIR/linux-smart-enumeration"
    chmod 700 lse.sh
fi

clone_repo "$GITHUB/411Hall/JAWS.git" "$WORKDIR/JAWS"
clone_repo "$GITHUB/bitsadmin/wesng.git" "$WORKDIR/wesng"
if [ -d "$WORKDIR/wesng" ]; then
    cd "$WORKDIR/wesng"
    python3 wes.py --update
fi

clone_repo "$GITHUB/absolomb/WindowsEnum.git" "$WORKDIR/WindowsEnum"
clone_repo "$GITHUB/cckuailong/Log4j_CVE-2021-45046.git" "$WORKDIR/Log4j_CVE-2021-45046"
clone_repo "$GITHUB/lgandx/Responder.git" "$WORKDIR/Responder"
clone_repo "$GITHUB/SecWiki/windows-kernel-exploits.git" "$WORKDIR/windows-kernel-exploits"

# Clone and setup CVE-2021-4034 repositories
clone_repo "$GITHUB/joeammond/CVE-2021-4034.git" "$WORKDIR/CVE-2021-4034_python"
clone_repo "$GITHUB/c3c/CVE-2021-4034.git" "$WORKDIR/CVE-2021-4034_precompiled"
clone_repo "$GITHUB/berdav/CVE-2021-4034.git" "$WORKDIR/CVE-2021-4034"
if [ -d "$WORKDIR/CVE-2021-4034" ]; then
    cd "$WORKDIR/CVE-2021-4034"
    make
fi

mkdir -p "$WORKDIR/blasty-vs-pkexec2"
cd "$WORKDIR/blasty-vs-pkexec2"
curl https://haxx.in/files/blasty-vs-pkexec2.c -o blasty-vs-pkexec2.c
gcc -o blasty-vs-pkexec2.so -fPIC -shared blasty-vs-pkexec2.c -Wl,-e,entry

mkdir -p "$WORKDIR/CVE-2021-4034_custom_command"
clone_repo "$GITHUB/zhzyker/CVE-2021-4034.git" "$WORKDIR/CVE-2021-4034_custom_command"
if [ -d "$WORKDIR/CVE-2021-4034_custom_command" ]; then
    cd "$WORKDIR/CVE-2021-4034_custom_command"
    gcc cve-2021-4034.c -o cve-2021-4034
fi

echo "Done"
