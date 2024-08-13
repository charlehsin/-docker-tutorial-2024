# docker-tutorial-2024

Docker learning tutorial in 2024. This is mainly to follow [Docker & Kubernetes: The Practical Guide [2024 Edition]
on Udemy](https://intel.udemy.com/course/docker-kubernetes-the-practical-guide).

## Installation

Install Docker Engine on WSL-Ubuntu.

1. Check system requirements at [Install Docker Desktop on Windows](https://docs.docker.com/desktop/install/windows-install/). We are not installing Docker Desktop. We are only checking the system requirements.
2. Follow [How to install Linux on Windows with WSL](https://learn.microsoft.com/en-us/windows/wsl/install) to install WSL 2 and Ubuntu.
3. After WSL - Ubuntu is setup, at WSL, follow [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/).
4. At WSL, check out [docker commands](https://docs.docker.com/get-started/docker_cheatsheet.pdf).
   * Notes: we may need to use "sudo docker XXXX" at Ubuntu.

## Tutorials

### 1-1

Check the codes folder.

1. docker build .
2. docker run -p 3000:3000 image_id
3. Open a browser and go to localhost:3000.
4. At another bash terminal
   * docker ps: to check the running containers.
   * docker stop container_name

### 2-1

1. docker run node
2. docker ps -a
3. docker run -it node
4. Check and delete container
   * docker ps -a
   * docker rm image_id/image_name
5. Check and delete image
   * docker image ls
   * docker rmi image_id
