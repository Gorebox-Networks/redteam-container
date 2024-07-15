# ~/.zshrc

# Oh My Zsh configuration
export ZSH="/root/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Custom Banner
echo "__________           .______________                     _________                __         .__                     "
echo "\\______   \\ ____   __| _/\\__    ___/___ _____    _____   \\_   ___ \\  ____   _____/  |______  |__| ____   ___________ "
echo " |       _// __ \\ / __ |   |    |_/ __ \\\\__  \\  /     \\  /    \\  \\/ /  _ \\ /    \\   __\\__  \\ |  |/    \\_/ __ \\_  __ \\"
echo " |    |   \\  ___// /_/ |   |    |\\  ___/ / __ \\|  Y Y  \\ \\     \\___(  <_> )   |  \\  |  / __ \\|  |   |  \\  ___/|  | \\/"
echo " |____|_  /\\___  >____ |   |____| \\___  >____  /__|_|  /  \\______  /\\____/|___|  /__| (____  /__|___|  /\\___  >__|   "
echo "        \\/     \\/     \\/              \\/     \\/      \\/          \\/            \\/          \\/        \\/     \\/      "
echo ""
echo "by cbk914"
echo ""
echo "Instructions:"
echo "- Use \`msfconsole\` to start Metasploit."
echo "- Use \`nmap\` for network scanning."
echo "- Use \`screen -r redteam\` to attach to the main screen session."

#alias ls='ls -lah'
alias myip='curl https://ifconfig.me; echo'

function mkrt(){
        mkdir {burp,osint,mobile,nmap,exploits,infra,wireless,phishing,reports,targets,vulns,zap}
}


