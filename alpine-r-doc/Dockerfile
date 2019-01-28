# ci-bases/alpine-R3.5/alt/Dockerfile
# --------------------------------------------------
# Intermediate image used to create the base
# we install pandoc and some base R packages in here 
# to speed up the build of the final image
# --------------------------------------------------

FROM alpine:latest as builder

# ------------------------------------------
# Environment variables and build arguments
# ------------------------------------------
ARG FS_VERSION=${FS_VERSION:-1.2.6}


COPY ["ci-bases/alpine-R3.5/install_apk.sh", "/opt/"]

RUN apk upgrade --update \
    && apk add --no-cache R R-dev \
    && sh /opt/install_apk.sh

#  get pandoc 
RUN wget https://gitlab.com/ConorIA/alpine-pandoc/raw/master/conor@conr.ca-584aeee5.rsa.pub -O /etc/apk/keys/conor@conr.ca-584aeee5.rsa.pub \
    && echo https://conoria.gitlab.io/alpine-pandoc/ >> /etc/apk/repositories \
    && echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache cmark@testing pandoc pandoc-citeproc


WORKDIR /usr/share/doc/R/html

RUN mkdir ~/.R \
    #  you have to set this flags or Rccp does not work at all in Alpine
    && echo 'CXXFLAGS  += -D__MUSL__'>> ~/.R/Makevars \
    && echo 'CXX1XFLAGS += -D__MUSL__'>> ~/.R/Makevars \ 
    # Add default CRAN mirror
    && echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"))' >> /usr/lib/R/etc/Rprofile.site \
    && cd /tmp/ \
    # fs still needs to be installed from source
    && curl -O https://codeload.github.com/r-lib/fs/tar.gz/v${FS_VERSION} \
    && tar -zxf v${FS_VERSION} \
    && { echo -n "#include <uv.h>"; cat fs-${FS_VERSION}/src/RcppExports.cpp; } > fs-${FS_VERSION}/src/RcppExports.cpp.new \
    && mv fs-${FS_VERSION}/src/RcppExports.cpp.new fs-1.2.6/src/RcppExports.cpp \
    && cd fs-${FS_VERSION}/src/libuv \
    && ls \
    && aclocal \
    && automake \
    && autoconf \
    #  also need to install Rcpp before fs install is completed
    && R -e "install.packages('Rcpp')" \
    # Install fs package from source
    && R CMD INSTALL /tmp/fs-1.2.6  \
    && Rscript -e 'install.packages(c("pacman", "markdown","devtools", "knitr"))'

# -----------------
# Final R image
# -----------------

FROM alpine:latest

COPY ["ci-bases/alpine-R3.5/install_apk.sh", "/opt/"]

RUN apk upgrade --update \
    && apk add --no-cache R R-dev \
    && sh /opt/install_apk.sh \
    && wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | sh

# faster! 
COPY --from=builder /usr/lib/R /usr/lib/R
COPY --from=builder /usr/bin/pandoc /usr/bin/pandoc
COPY --from=builder /usr/share/pandoc /usr/share/pandoc
COPY --from=builder /usr/share/pandoc-citeproc /usr/share/pandoc-citeproc
COPY --from=builder /usr/lib/libgmp.so.10 /usr/lib/libgmp.so.10

RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"))' >> /usr/lib/R/etc/Rprofile.site 

ENV PATH="$HOME/bin:${PATH}"

CMD ["R"]