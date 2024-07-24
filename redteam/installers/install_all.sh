#!/bin/bash

echo "Installing all Red Team tools..."

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
  "c2.sh"  # Added c2.sh for C2 tools
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
