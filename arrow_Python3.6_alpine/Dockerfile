# I created the builder to save time as arrow needs to be 
# compiled from source and it takes a very long time 

FROM python:3.6-alpine3.8 

# ------------------------------------------------
# Compile arrow from source because it is a pain
# ------------------------------------------------

RUN apk add --no-cache --virtual .build-deps \
    git \
    build-base \
    cmake \
    bash \
    jemalloc-dev \
    boost-dev \
    autoconf \
    zlib-dev \
    flex \
    bison \
    && pip install six numpy pandas cython pytest \
    && git clone https://github.com/apache/arrow.git\ 
    && mkdir /arrow/cpp/build    

WORKDIR /arrow/cpp/build

ENV ARROW_BUILD_TYPE=release
ENV ARROW_HOME=/usr/local
ENV PARQUET_HOME=/usr/local

#disable backtrace
RUN sed -i -e '/_EXECINFO_H/,/endif/d' -e '/execinfo/d' ../src/arrow/util/logging.cc \
    && cmake -DCMAKE_BUILD_TYPE=$ARROW_BUILD_TYPE \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_INSTALL_PREFIX=$ARROW_HOME \
    -DARROW_PARQUET=on \
    -DARROW_PYTHON=on \
    -DARROW_PLASMA=on \
    -DARROW_BUILD_TESTS=OFF \
    ..
# do the compilation in parallel
RUN make -j5
RUN make install

WORKDIR /arrow/python

RUN python setup.py build_ext --build-type=$ARROW_BUILD_TYPE \
    --with-parquet --inplace \
    && apk del .build-deps