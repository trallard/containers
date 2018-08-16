FROM rocker/rstudio:3.3.2

# R pre-requisites and install pacman

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \ 
    libssl-dev \
    libcurl4-openssl-dev \
    gfortran \
    gcc && apt-get clean && \
    R -e "install.packages('pacman')" && \
    R -e "install.packages('devtools')" && \
    echo 'if (!require("pacman")) install.packages("pacman")' >> /etc/R/Rprofile.site && \
    rm -rf /var/lib/apt/lists/*

# Copy script to install packages using pacman
COPY ./DockerConfig/pacmanInstall.R /tmp/pacmanInstall.R

# Install required packages
RUN Rscript /tmp/pacmanInstall.R 

# create an R user
ENV USER rstudio