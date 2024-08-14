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

### 1: Getting started

#### 1-1: Quick sample to run a container

Check the codes folder.

1. docker build .
2. docker run -p 3000:3000 image_id
3. Open a browser and go to localhost:3000.
4. At another bash terminal
   * docker ps: to check the running containers.
   * docker stop container_name

### 2: Core building blocks

#### 2-1: Running an external image

1. docker run node
2. docker ps -a
3. docker run -it node
4. Check and delete container
   * docker ps
      * This shows running container.
   * docker ps -a
      * This shows all container.
   * docker rm image_id/image_name
5. Check and delete image
   * docker image ls
   * docker rmi image_id

#### 2-2: Run a Node.js app

Check the codes folder.

1. docker build .
2. docker image ls
3. docker run image_id
4. Open a browser and go to localhost.  This won't work.
5. Check and stop container
   * docker ps
   * docker stop container_name
6. docker run -p 3000:80 image_id
7. Open a browser and go to localhost:3000. This should work.
8. Check and stop container
   * docker ps
   * docker stop container_name

#### 2-3: Optimize the build by understanding the image layers

Compare the Dockerfile with the 2-2. With this improvement, if we change the server.js, "npm install" layer won't need to be run again and Docker will use cache.

#### 2-4: Stopping and restarting containers

* Container commands
  * docker ps
    * This shows running container.
  * docker ps -a
    * This shows all container.
  * docker ps --help
    * This shows help messages.
  * docker run image_id
    * This creates and runs a new container in the foreground (attached mode). In attached mode, we can see the log message for "console.log".
    * By default, "run" is in attached mode.
  * docker start container_id/name
    * This starts/runs an existing container again in the background (detached mode). In detached mode, we cannot see the log message for "console.log".
    * By default, "start" is in detached mode.
  * docker run -d image_id
    * This creates and runs a new container in the background (detached mode).
  * docker start -a container_id/name
    * This starts/runs an existing container again in the foreground (attached mode).
  * docker attach container_id/name
    * This attaches to a running container. This can make us see the log messages.
    * We can also use "docker logs container_id/name" to see the log messages in detached mode.
      * docker logs --help

#### 2-5: Interactive mode

Check the codes folder.

1. docker --help
2. docker run -i -t image_id
   * Or docker run -it image_id
3. docker start --help
4. docker start -a -i container_id/name
   * This restarts the container in attached and interactive mode.

#### 2-6: Deleting images and containers

* container commands
  * docker stop container_name
    * This stops the container.
  * docker rm container_name
    * This removes the container.
  * docker rm container_name1 container_name2 container_name3
    * This removes multiple containers.
  * docker run --help
  * docker run --rm image_id
    * This auto-removes the image after the container exits.
* image commands
  * docker rmi image_id
    * This removes the image.
  * docker rmi image_id1 image_id2 image_id3
    * This removes multiple images.
  * docker image prune
    * This removes all not-used images.

#### 2-7: Inspecting image

* docker image inspect image_id

#### 2-8: Copying into and from container

* docker cp source_path container_name:dest_path
  * docker cp dummy/. boring_vaughan:/test
* docker cp container_name:source_path dest_path
  * docker cp boring_vaughan:/test dummy

#### 2-9: Naming and tagging containers and images

* docker run --name name_you_want image_id
  * Gives a custom name to the container.
* docker build -t name:tag .
  * Gives name:tag to the image.

#### 2-10: Sharing images at DockerHub

* Push
  * docker tag local-name:tagname new-repo:tagname
  * docker login
  * docker push new-repo:tagname
* Pull
  * docker logout
  * docker pull new-repo:tagname

### 3: Data and volumes

#### 3-1: Check a real app

Check the codes folder.

1. docker build -t feedback-node .
2. docker run -p 3000:80 -d --name feedback-app --rm feedback-node
3. At the web site <http://localhost:3000>, write title = Test1, message = test2. Save.
4. At the browser, navigate to <http://localhost:3000/feedback/test1.txt>.
   * This is just a temporary file only existing at the container. This file will be kept when you stop and then restart the container. However, this file will be lost when you remove and then re-create teh container.
