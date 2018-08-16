#!/bin/bash
# This is s simple docker run command, broken up so you can read each bit
# -d flag runs in detatched mode
# use -it to start in interactive mode
# --rm removes the container on exit useful if spinning loads of containers 
# and not to fill up our memory

#docker run -d --rm \   
#    -p 8787:8787 \                          # map ports, you can change the local e.g. -p 28787:8787
#    --name model_container \                # name of your container
#    -e USERID=$UID \                        # you need to share a UID so you can write to mount file on host
#    -e PASSWORD=rstudio \                   # set rstudio password - user is rstudio
#    -v $DATA_DIR:/home/rstudio/Data \       # mount data directory to pick up changes or write to host 
#       rstudio/hello-world                  # the name of the image

# one liner for command line copying

DATA_DIR=${PWD}/Data
docker run -d --rm -p 28787:8787 --name hello-analytics -e USERID=$UID -v $DATA_DIR:/home/rstudio/Data rstudio/hello-world

# this is an example of running the container in interactive mode and logging into a bash shell
# sudo docker run -it --rm  --name hello-world2 -e USERID=$UID -v $DATA_DIR:/home/rstudio/Data rstudio/hello-world  /bin/bash

docker run -it --rm -v $(pwd):/home/rstudio -p 8787:8787 --name analytics -e USERID=$UID trallard/r_ws