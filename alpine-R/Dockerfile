# ci-bases/alpine-R3.5/Dockerfile
# this is meant to be used as the base for any CI creating images
# needing solely R3.5 for example when creating the shiny apps
#  (not for ws-adapter )

FROM alpine:latest

# ------------------------------------------
# Environment variables and build arguments
# ------------------------------------------
ARG R_VERSION
# ENV R_VERSION ${R_VERSION:-3.5.0}
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
# Do the package compilation in parallel
ENV MAKEFLAGS="-j 5"

# R version, also can be passed as an arg just in case
ENV R_VERSION 3.5.1
ARG R_VERSION

# need to create a user
ARG DF_USER="docker"
ARG DF_GID="1000"

COPY ["install_apk.sh", "install_r.sh", "/opt/"]

# -----------------------------------
# R compile and install
# -----------------------------------
## Set a default user. Available via runtime flag `--user docker`
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (for linked volumes to work properly).
RUN addgroup -g ${DF_GID} staff \
    && adduser -h /home/${DF_USER} -s /bin/bash -D ${DF_USER} -G staff \
    && chown -R ${DF_USER} /home/${DF_USER} \
    && sh /opt/install_apk.sh

RUN cd /tmp \
    && sh /opt/install_r.sh 

ARG FS_VERSION=${FS_VERSION:-1.2.6}

RUN cd /tmp \
    && mkdir ~/.R \
    #  you have to set this flags or Rccp does not work at all in Alpine
    && echo 'CXXFLAGS  += -D__MUSL__'>> ~/.R/Makevars \
    && echo 'CXX1XFLAGS += -D__MUSL__'>> ~/.R/Makevars \
    && curl -O https://codeload.github.com/r-lib/fs/tar.gz/v${FS_VERSION} \
    && tar -zxf v${FS_VERSION} \
    && { echo -n "#include <uv.h>"; cat fs-${FS_VERSION}/src/RcppExports.cpp; } > fs-${FS_VERSION}/src/RcppExports.cpp.new \
    && mv fs-${FS_VERSION}/src/RcppExports.cpp.new fs-1.2.6/src/RcppExports.cpp \
    && cd fs-${FS_VERSION}/src/libuv \
    && ls \
    && aclocal \
    && automake \
    && autoconf \
    && R -e "install.packages(c('pacman', 'Rcpp'))" \
    # Install fs package from source
    && R CMD INSTALL /tmp/fs-1.2.6 

# Remove build dependencies and artefacts
RUN rm -rf /tmp/* \
    rm -rf /usr/lib/R/library/translations

CMD [ "R" ]
