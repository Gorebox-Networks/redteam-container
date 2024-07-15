#!/bin/bash

screen -dmS redteam

screen -S redteam -X screen -t Shell zsh
screen -S redteam -X screen -t Nmap zsh -c "nmap --help; exec zsh"
screen -S redteam -X screen -t Metasploit msfconsole

screen -r redteam