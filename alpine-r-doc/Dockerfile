FROM alpine:3.8

RUN apk upgrade --update
RUN apk add --no-cache gcc g++
RUN apk add R R-dev --no-cache

RUN wget https://gitlab.com/ConorIA/alpine-pandoc/raw/master/conor@conr.ca-584aeee5.rsa.pub -O /etc/apk/keys/conor@conr.ca-584aeee5.rsa.pub
RUN echo https://conoria.gitlab.io/alpine-pandoc/ >> /etc/apk/repositories
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --no-cache cmark@testing pandoc pandoc-citeproc

RUN Rscript -e "install.packages(c('knitr', 'rmarkdown'), repos = 'https://cloud.r-project.org/')"
