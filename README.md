# RedTeam Container

## Overview

The RedTeam Container is a Docker image designed for use in GNS3 to simulate and test various red team tactics and techniques. This container includes a set of tools commonly used by penetration testers and security researchers.

## Installation

### Prerequisites

- Docker installed on your system. You can download and install Docker from [Docker's official site](https://www.docker.com/products/docker-desktop).
- GNS3 installed on your system. You can download and install GNS3 from [GNS3's official site](https://www.gns3.com/software/download).

### Docker Image

Pull the Docker image from Docker Hub:

    docker pull dvd42/redteam-container:latest
    
## GNS3 Configuration

* Open GNS3 and create a new project.
* Go to Edit > Preferences > Docker.
* Click on New to create a new Docker template.
* In the New template window, select Run this container: dvd42/redteam-container.
* Fill in the template details:
    Name: RedTeam Container
    Category: Docker
    Image: dvd42/redteam-container
* Click Next and adjust network settings if needed. Default settings should be sufficient for most cases.
* Click Finish to create the template.

## Adding the Container to Your GNS3 Project

* Save the following JSON configuration into a file named redteam-container.gns3:

    {
        "version": "2.2.16",
        "project_id": "redteam-container",
        "topology": {
            "nodes": [
                {
                    "compute_id": "local",
                    "console_type": "telnet",
                    "name": "RedTeam Container",
                    "node_id": "node1",
                    "node_type": "docker",
                    "properties": {
                        "container_id": "dvd42/redteam-container",
                        "console_http_port": 80,
                        "console_https_port": 443,
                        "console_ssh_port": 22,
                        "env": [],
                        "start_command": null
                    },
                    "symbol": ":/symbols/docker_guest.svg",
                    "x": 0,
                    "y": 0,
                    "z": 1
                }
            ],
            "links": []
        }
    }


* Open GNS3.
* Select File > Open Project.
* Navigate to the redteam-container.gns3 file you created and open it.

## Usage

* In GNS3, drag the RedTeam Container node from the device panel to the workspace.
* Right-click the node and select Start to launch the container.
* Connect to the container using the console option provided by GNS3.

## Legal Disclaimer
This project is intended for educational purposes only. The tools and techniques provided in this container should only be used in environments where you have explicit permission to perform penetration testing and security assessments. Unauthorized use of these tools is illegal and unethical.

By using this project, you agree to the following terms:

- You will not use this container for any illegal or unauthorized activities.
- You will obtain proper authorization before using the tools provided in this container in any environment.
- The creators of this project are not responsible for any misuse or damage caused by the use of this container.
- Use of this container is at your own risk. Ensure you comply with all applicable laws and regulations.

