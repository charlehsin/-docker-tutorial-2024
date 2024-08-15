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

#### 3-2: Anonymous volume

Volume is managed by Docker. Anonymous volume is associated with a container.

Check the codes folder. Check the "copyFile and unlink" at server.js, and the "VOLUME" at Dockerfile.

1. docker build -t feedback-node:volumes .
2. docker run -d -p 3000:80 --rm --name feedback-app feedback-node:volumes
3. At the web site <http://localhost:3000>, write title = Test1, message = test2. Save.
4. At the browser, navigate to <http://localhost:3000/feedback/test1.txt>.
5. If you stop the container (which will remove the container automatically) and then create/start the container again. The "test1.txt" is still not kept, even though we use volume.
6. docker volume --help
7. docker volume --ls
   * You can see the anonymous volume created by our container.
8. docker stop feedback-app
   * Stop the container.
9. docker volume --ls
   * The anonymous volume will be gone. This is why the "test1.txt" is not kept. The anonymous volume will be gone after the container is removed.
   * The anonymous volume will be auto-removed only when you create the container with "--rm". Else, the volume won't be auto-removed even though you stop the container and then remove the container. In this case, use "docker volume rm vol_name" or "docker volume prune".

#### 3-3: Named volume

Volume is managed by Docker. Named volume is not associated with a container.

Check the codes folder. Check the "copyFile and unlink" at server.js. Check that we don't have the "VOLUME" at Dockerfile. We need to create the named volume when we create the container.

1. docker build -t feedback-node:volumes .
2. docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback feedback-node:volumes
   * "-v" will let us create a named volume. The name is feedback.
3. At the web site <http://localhost:3000>, write title = Test1, message = test2. Save.
4. At the browser, navigate to <http://localhost:3000/feedback/test1.txt>.
5. If you stop the container (which will remove the container automatically) and then create/start the container again. The "test1.txt" will be kept now.
6. docker volume --help
7. docker volume --ls
   * You can see the named volume created by our container.
8. docker stop feedback-app
   * Stop the container.
9. docker volume --ls
   * The named volume will still be there.
10. docker volume rm vol_name
    * Remove the named volume.
    * Or docker volume prune

#### 3-4: Bind mounts

Bind mounts is managed by us. This is great for persistent, editable (by us) data (e.g., source codes).

Check the codes folder. Check the "copyFile and unlink" at server.js. Check that we don't have the "VOLUME" at Dockerfile. We need to create the bind mounts when we create the container.

Note that we still do "COPY . ." at Dockerfile. This is because "bind mount" is usually used during development so that we can easily modify our codes. For production, we won't use "bind mount" most likely and we will need "COPY . .".

1. docker build -t feedback-node:volumes .
2. docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback -v "full_path_at_host_desktop:/app" -v /app/node_modules feedback-node:volumes
   * The 1st "-v" is the named volume.
      * This is used to store the persistent data (e.g., the feedback data).
   * The 2nd "-v" is the bind mounts.
      * This is used to store the persistent, editable (by us) data (e.g., source codes).
      * The front is a host path to a folder/file that we want to the container to use. The second is the container path for the target folder/file.
      * By default, the bind mount on the host is read/write. If you want to set it to read-only (which prevents Docker from changing our host folder), add ":ro" to the end, like "full_path_at_host_desktop:/app:ro". If you do this, you may need to add 1 extra anonymous volume for /app/temp so the node.js app can still write temp files to it.
      * If there is issue for Docker to access the host path, check [Mounting Docker volumes with Docker Toolbox for Windows](https://headsigned.com/posts/mounting-docker-volumes-with-docker-toolbox-for-windows/).
   * The 3rd "-v" is an anonymous volume.
      * This is used to store temporary data, existed only when the container is not removed.
      * We need a place to store the "nodes packages" in /app created during image build. If we don't do this, the bind mount will override the /app when it is mounted, and we won't have "nodes packages" anymore. And the node application will crash.
   * When the multiple "-v" flags include partial sam subpath (e.g., /app, /app/feedback, /app/node_modules), the longer ones have higher priorities.
   * For example, docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback -v "/home/chsin/tutorials/3-4:/app" -v /app/node_modules feedback-node:volumes
3. At the web site <http://localhost:3000>, check the web page.
4. Modify the pages/feedback.html and save on the host. Refresh the web page. You can see the change.

#### 3-5: Bind mounts continued with nodemon package to auto restart node.js app

At the previous sample, if the code changes are at a .js file, then the changes won't be applied because node.js application is already running. To address this, we can use a npm package, nodemon.

Check the codes folder. Check the "scripts" and "devDependencies" at package.json. Check "CMD" at Dockerfile.

#### 3-6: Managing volumes

* docker volume --help

#### 3-7: dockerignore

We can use ".dockerignore" file to filter out files/folders that we don't want to copy in "COPY . ." at Dockerfile.

#### 3-8: ARGuments & ENVironment variables

Docker supports build-time ARGuments and runtime ENVironment variables.

Check the codes folder. Check the "process.env" at server.js and the "ENV" and "$PORT" at Dockerfile.

1. docker build -t feedback-node:volumes .
2. docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback -v "full_path_at_host_desktop:/app" -v /app/node_modules feedback-node:volumes
   * This will use the PORT value defined at Dockerfile.
   * For example, docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback -v "/home/chsin/tutorials/3-8:/app" -v /app/node_modules feedback-node:volumes
3. docker stop feedback-app
4. docker run -d -p 3000:8000 --env PORT=8000 --rm --name feedback-app -v feedback:/app/feedback -v "full_path_at_host_desktop:/app" -v /app/node_modules feedback-node:volumes
   * This will use the PORT value defined at the command-line argument (--env).
   * For example, docker run -d -p 3000:8000 --env PORT=8000 --rm --name feedback-app -v feedback:/app/feedback -v "/home/chsin/tutorials/3-8:/app" -v /app/node_modules feedback-node:volumes
   * For multiple environment variables, use multiple --env (or -e).
   * You can also use .env file instead of the command-line argument --env. You need "--env-file ./.env" command-line argument though.

#### 3-9: Using build arguments (ARG)

Check the codes folder. Check the "DEFAULT_PORT" at Dockerfile. The ARG can only be used in Dockerfile. Put the "ARG" right before it is used.

1. docker build -t feedback-node:volumes --build-arg DEFAULT_PORT=8000 .
   * "--build-arg" flag is to set the arguments key=value paris.

### 4: Networking: cross-container communication

#### 4-1: From container to WWW

Out-of-box, the communication from the container to WWW works.

Check the codes folder.

1. docker build -t favorites-node .
2. docker run --name favorites -d --rm -p 3000:3000 favorites-node
   * This will have the container crashed. This is due to we do not have a MongoDB server started yet.
3. At app.js, replace the mongoose.connect block with just app.listen(3000).
4. Rebuild the image and re-run the container. This time, we can send get request and get response.

#### 4-2: From container to host machine

It works, but it needs "host.docker.internal" to represent the host machine ip address.

Check the codes folder. Check "host.docker.internal" at app.js. "host.docker.internal" will be understandable by Docker to be mapped to an IP address for the host machine.

Then if you rebuild the image, and then start the container. It will work. The post request will also be saved to MongoDB.
