#!/bin/bash

# Apply credentials BEFORE anything exposes a service.
# This script is fail-closed: with no SSHPASSWORD it disables password
# authentication rather than leaving an empty password on a published port.
/root/set-credentials.sh

# Define a unique session name
SESSION_NAME="redteam_$(date +%s)"

# ASCII banner
# NOTE: the backticks in the art below are escaped. Unescaped they are parsed
# as command substitution, which made this file fail `bash -n` and meant the
# container entrypoint could not start at all.
BANNER="
::::::\       :| ::::::|                  ,::::\           :|       ++
::|,::|:~~/ :':|   ::|  :~~/ .::\ :\/|   ::|    ,::\ :::\ :::| .::\ :| :::\ :~~/ :::|
::| ::\:::, :::|   ::|  :::, \`::| :::|    '::::/\`::/ :|:|  :|  \`::| :| :|:| :::, :|
"

# Clean up dead sessions
screen -wipe > /dev/null 2>&1

# Check if the session already exists
if screen -list | grep -q "$SESSION_NAME"; then
    echo "Screen session $SESSION_NAME already exists. Attaching..."
    screen -r "$SESSION_NAME"
else
    # Create a new detached screen session
    echo "Creating new screen session: $SESSION_NAME"
    screen -dmS "$SESSION_NAME"

    # Create windows in the screen session
    screen -S "$SESSION_NAME" -X screen -t Banner bash -c "echo '$BANNER'; echo 'RedTeam Container'; echo 'https://github.com/Gorebox-Networks/redteam-container/tree/main/redteam/installers'; ls /root/RedTeamToolkit/installers; exec bash"
    screen -S "$SESSION_NAME" -X screen -t Shell zsh
    screen -S "$SESSION_NAME" -X screen -t Nmap zsh -c "nmap --help; exec zsh"
    screen -S "$SESSION_NAME" -X screen -t Metasploit msfconsole

    # Attach to the screen session
    screen -r "$SESSION_NAME"
fi

# Start supervisord
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
