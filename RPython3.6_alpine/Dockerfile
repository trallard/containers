#  contains both Python and R better used as a base as compiling R
#  from source takes a very (VERY) long time
#  also building arrow takes a loooong time so I created a builder for this too
# arrow_Python3.6_alpine

FROM python:3.6-alpine3.8 
# docker-build/rpython/Dockerfile.builder
# this should be the base image for the personal instances
# ssh-linux kernel, it is based on alpine to keep it smaller
# also it contains both Python and R better used as a base as compiling R
#  from source takes a very (VERY) long time
#  also building arrow takes a loooong time so I created a builder for this too
# docker-build/rpython/Dockerfile.arrowbuilder

FROM git.hellosoda.com:5005/infra/aux/personal-instances:rpython-alpine-builder-arrow-0.12.1

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
ARG GROUP="jovyan"

# set dev packages to install in R- always need to be present
ENV R_PKG devtools roxygen2 testthat 

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
# install defaults R packages for development, their install kept failling in the personal
# istances build
#  install R and fix paths
RUN cd /tmp/ \
    && sh /opt/install_r.sh \
    && Rscript -e 'install.packages(commandArgs(TRUE))' ${R_PKG} 

RUN addgroup -g ${DF_GID} ${GROUP} \
    # add jovyan user 
    && adduser -h /home/${DF_USER} -s /bin/bash -u ${DF_UID} -D ${DF_USER} -G ${GROUP} \
    # set proper permission for the new user
    && chown -R ${DF_USER} /home/${DF_USER} \
    && mkdir /root/.ssh/ /home/${DF_USER}/.ssh \
    && touch /home/${DF_USER}/.ssh/authorized_keys /root/.ssh/authorized_keys \
    && chmod 600 /home/${DF_USER}/.ssh/authorized_keys \
    && ssh-keygen -A \
    && sed -i s/^#PasswordAuthentication\ yes/PasswordAuthentication\ no/ /etc/ssh/sshd_config \
    && sed -i s/#PermitRootLogin.*/PermitRootLogin\ no/ /etc/ssh/sshd_config \
    && sed -i s/#ChallengeResponseAuthentication.*/ChallengeResponseAuthentication\ no/ /etc/ssh/sshd_config \
    && echo "AllowUsers ${DF_USER}" >> /etc/ssh/sshd_config \
    # fix permissions
    && chmod 700 /root/.ssh \
    && chmod 700 /home/${DF_USER}/.ssh \
    && chown ${DF_USER} /root/.ssh/authorized_keys \
    && chmod 600 /root/.ssh/authorized_keys \
    && chown ${DF_USER}:${GROUP} /root/.ssh/authorized_keys \
    #  creates the ssh keys
    && chmod +x /opt/entrypoint.sh \
    # alpine was locking my user so this needed some help here
    && sed -i s/jovyan:!/"jovyan:*"/g /etc/shadow \
    && chown -R jovyan /home/jovyan/.ssh/ \
    && cd /  


# This image expects AUTHORIZED_KEYS environment variable to contain your ssh public key.

# -----------------------------------
# Cleanup
# -----------------------------------
COPY ["cleanup.sh", "/opt/"]
RUN sh /opt/cleanup.sh

# ensure we are an unpriviledged user
USER ${DF_USER}
WORKDIR /home/${DF_USER}

RUN  chown -R jovyan /home/jovyan/

# needed for the ssh session
EXPOSE 22

# should create an ssh key
ENTRYPOINT [ "/opt/entrypoint.sh" ]


# -D in CMD below prevents sshd from becoming a daemon. -e is to log everything to stderr.
# do not detach (-D), log to stderr (-e), passthrough other arguments
CMD ["/usr/sbin/sshd", "-D", "-e"]

