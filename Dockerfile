version: '3.8'

services:
  redteam:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: redteam_container
    ports:
      - "22:22"
    environment:
      SSHPASSWORD: ${SSHPASSWORD}
    volumes:
      - ./conf:/root/.vimrc:/root/.vimrc
      - ./conf:/root/.zshrc:/root/.zshrc
      - ./conf:/root/.bashrc:/root/.bashrc
      - ./conf/sshd_config:/etc/ssh/sshd_config
      - ./installers:/root/RedTeamToolkit
