# Download source code
curl -O https://cran.r-project.org/src/base/R-3/R-${R_VERSION}.tar.gz && \
# Extract source code
tar -xf R-${R_VERSION}.tar.gz && \
cd R-${R_VERSION} && \
# Set compiler flags
CFLAGS="-g -O2 -fstack-protector-strong -D_DEFAULT_SOURCE -D__USE_MISC" \
CXXFLAGS="-g -O2 -fstack-protector-strong -D_FORTIFY_SOURCE=2 -D__MUSL__" \
# configure script options
./configure --prefix=/usr \
--sysconfdir=/etc/R \
--localstatedir=/var \
rdocdir=/usr/share/doc/R \
rincludedir=/usr/include/R \
rsharedir=/usr/share/R \
--enable-memory-profiling \
--enable-R-shlib \
--disable-nls \
--without-x \
--without-recommended-packages && \
# Build and install R
make && \
make install && \
cd src/nmath/standalone && \
make && \
make install && \
rm -f /usr/lib/R/bin/R && \
ln -s /usr/bin/R /usr/lib/R/bin/R && \
# Fix library path
echo "R_LIBS_SITE=\${R_LIBS_SITE-'/usr/local/lib/R/site-library:/usr/lib/R/library'}" >> /usr/lib/R/etc/Renviron && \
# Add default CRAN mirror
echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"))' >> /usr/lib/R/etc/Rprofile.site && \
# Add symlinks for the config file in /etc/R
mkdir -p /etc/R && \
ln -s /usr/lib/R/etc/* /etc/R/ && \
# Add library directory
mkdir -p /usr/local/lib/R/site-library && \
chgrp users /usr/local/lib/R/site-library

