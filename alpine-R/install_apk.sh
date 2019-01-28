# R runtime dependencies
apk --no-cache add \
gcc \
gfortran \
g++ \
make \
readline-dev \
icu-dev \
bzip2-dev \
xz-dev \
pcre-dev \
libjpeg-turbo-dev \
libpng-dev \
tiff-dev  \
curl-dev \
zip \
file \
coreutils \
musl \
git \
libxml2 \
bash && \
# R build dependencies
apk --no-cache add --virtual build-deps \
curl \
perl \
openjdk8-jre-base \
pango-dev \
cairo-dev \
tcl-dev \
tk-dev \
automake \
libtool \
m4 \
autoconf \
linux-headers \
libxml2-dev