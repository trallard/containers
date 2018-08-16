FROM python:3.6.4-stretch
LABEL maintainer="Tania Allard <tania.allard@hellosoda.com>"

RUN apt-get update && \
    wget -q "https://deb.nodesource.com/node_6.x/pool/main/n/nodejs/nodejs_6.11.5-1nodesource1_amd64.deb" -O "nodejs.deb" && \
    dpkg -i "nodejs.deb" && \
    rm "nodejs.deb" && \
    apt-get install -y 'libzmq3-dev=4.2.1-4' && \
    npm install 'zeromq@4.6.0' --zmq-external && \
    npm install 'ajv@5.2.3' && \
    apt-get clean

ARG Rversion=3.3.3-1

RUN apt-get update && \
    apt-get install -y libcurl4-openssl-dev libxml2-dev libssl-dev && \
    apt-get install -y r-base=$Rversion && \
    apt-get install -y r-base-dev=$Rversion && \
    apt-get install -y r-recommended=$Rversion && \
    apt-get clean

WORKDIR /install
RUN echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site && \
    R -e "install.packages('pacman')" && \
    echo 'if (!require("pacman")) install.packages("pacman")' >> /etc/R/Rprofile.site && \
    rm -rf /var/lib/apt/lists/*

COPY ./DockerConfig/pacmanInstall.R /tmp/pacmanInstall.R

# Install required packages
RUN Rscript /tmp/pacmanInstall.R 

WORKDIR /app
COPY requirements.txt ./
RUN pip install --upgrade pip && \ 
    pip install -r requirements.txt

# set the command
CMD ["R"]

