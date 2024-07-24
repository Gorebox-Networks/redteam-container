FROM kalilinux/kali-bleeding-edge:latest
LABEL author="cbk914"
LABEL description="Container for Red Team Campaign"
ARG SSHPASSWORD
ARG DEBIAN_FRONTEND=noninteractive

# PACKAGES #
ARG packages="openssh-server zsh net-tools apt-utils python3 python3-dev build-essential python3-pip redis-server terminator \
    wget vim gnupg2 postgresql python3-venv apt-transport-https lsb-release libreadline-dev libpq5 libpq-dev readline-common libsqlite3-dev libpcap-dev \
    subversion git-core autoconf zlib1g-dev libxml2-dev libxslt1-dev libyaml-dev ruby1.9.1 nmap iputils-ping netdiscover hping3 \
    netcat-traditional gobuster iproute2 iputils-arping dnsutils tcpdump curl git screen xfce4 xfce4-goodies tightvncserver dbus-x11 x11-xserver-utils supervisor \
    bash-completion locales less nano"

# Configuration files
COPY conf/.vimrc /root/.vimrc
COPY conf/.zshrc /root/.zshrc
COPY conf/.bashrc /root/.bashrc
COPY conf/sshd_config /etc/ssh/sshd_config
COPY installers/start.sh /root/start.sh

RUN chmod +x /root/start.sh

RUN apt-get update && apt-get upgrade -y && apt-get install -y $packages && pip3 install charset

# Configure locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended && \
    chsh -s $(which zsh)

RUN git --version

# RedTeamToolkit 
RUN mkdir /root/RedTeamToolkit
COPY installers/*.sh /root/RedTeamToolkit/
RUN chmod +x /root/RedTeamToolkit/*.sh && cd /root/RedTeamToolkit && git clone https://github.com/som3canadian/Some-Tools.git && cd Some-Tools && chmod +x sometools.sh && \
    ./sometools.sh setup

# Python env
RUN ln -s /usr/bin/python3 /usr/bin/python

# Setup for ssh (change password ASAP)
RUN echo "root:$SSHPASSWORD" | chpasswd

# Expose ports for SSH and VNC
EXPOSE 22 5901

# Cleanup
RUN touch /root/.hushlogin && apt-get autoremove -y && apt-get autoclean -y

# Supervisor configuration for VNC
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Source bash completion
RUN echo "if [ -f /etc/bash_completion ]; then\n . /etc/bash_completion\nfi" >> /root/.bashrc

# Start script
COPY installers/start.sh /root/start.sh
RUN chmod +x /root/start.sh

WORKDIR /root/RedTeamToolkit

CMD ["/usr/bin/supervisord"]
# CMD ["/root/start.sh"]
