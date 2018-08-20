FROM python:3.6.4-stretch

RUN apt-get update && \
    wget -q "https://deb.nodesource.com/node_6.x/pool/main/n/nodejs/nodejs_6.11.5-1nodesource1_amd64.deb" -O "nodejs.deb" && \
    dpkg -i "nodejs.deb" && \
    rm "nodejs.deb" && \
    apt-get install -y 'libzmq3-dev=4.2.1-4' && \
    npm install 'zeromq@4.6.0' --zmq-external && \
    npm install 'ajv@5.2.3' && \
    apt-get clean

RUN apt-get update && \
    curl -o libenchant1c2a.deb 'http://snapshot.debian.org/archive/debian/20140825T220927Z/pool/main/e/enchant/libenchant1c2a_1.6.0-10.1_amd64.deb' && \
    dpkg -i --force-all libenchant1c2a.deb && \
    apt-get install -yf && \
    rm libenchant1c2a.deb && \
    apt-get install -y 'libatlas-base-dev=3.10.3-1+b1' && \
    apt-get install -y 'liblapack-dev=3.7.0-2' && \
    apt-get clean && \
    pip3 install pipenv

WORKDIR /install
COPY ./Pipfile Pipfile
COPY ./Pipfile.lock Pipfile.lock

# Make sure the locales are set up properly
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# Install dependencies
RUN pipenv install --system --deploy