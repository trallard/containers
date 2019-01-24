# apk installs -using virtual to do the cleanup later
apk --upgrade add --no-cache \
bash \
bzip2-dev \
cmake \
curl-dev \
coreutils \
file \
freetype \
git \
g++ \
gcc \
gfortran \
hdf5 \
harfbuzz-dev \
jq \
jpeg-dev \
icu-dev \
lcms2-dev \
libexecinfo-dev \
libgomp \
libjpeg-turbo-dev \
libpng \
libstdc++ \
make \
nano \
openssh \
openblas-dev \
openjpeg-dev \
pcre-dev \
readline-dev \
tiff-dev  \
vim \
xz-dev \
zip \
zlib-dev \
curl \
libressl-dev \
libxmu-dev \
libxml2-dev && \

# build dependencies
apk add --no-cache --virtual .build-deps \
hdf5-dev \
build-base \
cairo-dev \
curl \
freetype-dev \
libpng-dev \
musl-dev \
pango-dev \
perl \
openjdk8-jre-base \
tcl-dev \
tk-dev \
libffi-dev