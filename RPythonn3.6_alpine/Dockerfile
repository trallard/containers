#  contains both Python and R better used as a base as compiling R
#  from source takes a very (VERY) long time
#  also building arrow takes a loooong time so I created a builder for this too
# arrow_Python3.6_alpine

FROM python:3.6-alpine3.8 

# -----------------------------------
# Environment variables and sutff
# -----------------------------------
# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LC_ALL en_GB.UTF-8
ENV LANG en_GB.UTF-8

# R version, also can be passed as an arg just in case
ENV R_VERSION 3.5.1
ARG R_VERSION

# user and ids and the such
ARG DF_USER="jovyan"
ARG DF_UID="1001"
ARG DF_GID="1001"

# set dev packages to install in R- always need to be present
ENV R_PKG devtools roxygen2 testthat Rccp

# -----------------------------------
# Add python and R dependencies
# as well as the entrypoint
# -----------------------------------
COPY ["install_apk.sh", "install_r.sh", "entrypoint.sh", "cleanup.sh", "/opt/"]

# Installs apk dependencies needed by multiple R and Python libraries
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache hdf5 \
    # && apk add --no-cache --virtual .build-deps build-base hdf5 hdf5-dev libffi-dev --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
    && sh /opt/install_apk.sh \
    && ln -s /usr/include/locale.h /usr/include/xlocale.h 

# -----------------------------------
# R compile and install
# -----------------------------------
#  install R and fix paths
RUN cd /tmp/ \
    && sh /opt/install_r.sh 

RUN Rscript -e 'install.packages(commandArgs(TRUE))' ${R_PKG} \
    # fix groups and permissions here
    && addgroup -g ${DF_GID} data-users \
    && adduser -h /home/${DF_USER} -s /bin/bash -u ${DF_UID} -D ${DF_USER} -G data-users \
    && chown -R ${DF_USER} /home/${DF_USER} \
    && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
    && chmod +x /opt/entrypoint.sh \
    && cd /  

# -----------------------------------
# Cleanup
# -----------------------------------
COPY ["cleanup.sh", "/opt/"]
RUN sh /opt/cleanup.sh

# ensure we are an unpriviledged user
USER ${DF_USER}
WORKDIR /home/${DF_USER}

# needed for the ssh session
EXPOSE 22

# should create an ssh key
ENTRYPOINT [ "/opt/entrypoint.sh" ]
