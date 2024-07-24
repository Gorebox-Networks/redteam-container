#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "Installing all Red Team tools..."

# Ensure the shared directory for the package exists
SHARED_DIR="/root/RedTeamToolkit/shared"
mkdir -p $SHARED_DIR

# Download the package only if it doesn't exist
if [ ! -f "$SHARED_DIR/packages-microsoft-prod.deb" ]; then
  curl -o $SHARED_DIR/packages-microsoft-prod.deb https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
fi

# Define the list of installer scripts
installers=(
  "anon.sh"
  "activedirectory.sh"
  "evasion.sh"
  "exfiltration.sh"
  "exploitation.sh"
  "mobile.sh"
  "osint.sh"
  "phishing.sh"
  "postexploitation.sh"
  "privilege_escalation.sh"
  "vulnscan.sh"
  "weaponization.sh"
  "c2.sh"
  "wireless.sh"  # Added wireless.sh for wireless tools
)

# Loop through each installer script and execute it
for installer in "${installers[@]}"; do
  if [[ -f "$installer" ]]; then
    echo "Running $installer..."
    ./$installer
  else
    echo "Error: $installer not found!"
  fi
done

echo "Done!"
