FROM rocker/rstudio:latest
LABEL maintainer="tania.allard@hellosoda.com"

# R pre-requistes
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  libxml2-dev \ 
  libssl-dev \
  libcurl4-openssl-dev \
  libnlopt-dev \
  && . /etc/environment \
  && install2.r --error \
    --repos 'http://www.bioconductor.org/packages/release/bioc' \
    --repos $MRAN \
    caret 
