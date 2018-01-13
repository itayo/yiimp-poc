FROM ubuntu:16.04

MAINTAINER stenyg
RUN apt-get update
RUN apt-get install -qyy --force-yes software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -qyy --force-yes build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev libdb4.8-dev libdb4.8++-dev sudo aptitude git

RUN mkdir /build
RUN chmod -R 777 /build


# Build gobyte-core
RUN git clone https://github.com/gobytecoin/gobyte.git /build/gobyte
WORKDIR "/build/gobyte"
RUN git checkout v0.12.1.3
RUN ./autogen.sh
RUN ./configure --disable-tests
RUN make -j4
RUN make install

# Build UFO

RUN git clone https://github.com/UFOCoins/ufo.git /build/ufo 
WORKDIR "/build/ufo"
RUN git checkout v0.11.0.0
RUN chmod +x autogen.sh
WORKDIR "/build/ufo/share"
RUN chmod +x genbuild.sh
WORKDIR "/build/ufo"
RUN ./autogen.sh
RUN ./configure --disable-tests
RUN make -j4
RUN make install
# Build Desire

RUN git clone https://github.com/lazyboozer/Desire.git /build/desire
WORKDIR "/build/desire"
RUN git checkout Desire-v.0.12.2.1
RUN chmod +x autogen.sh
WORKDIR "/build/desire/share"
RUN chmod +x genbuild.sh
WORKDIR "/build/desire"
RUN ./autogen.sh
RUN ./configure --disable-tests
RUN make -j4
RUN make install



RUN useradd -ms /bin/bash yiimp
RUN useradd -ms /bin/bash gobyte
RUN useradd -ms /bin/bash stratum
RUN echo "yiimp ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/yiimp && \
    chmod 0440 /etc/sudoers.d/yiimp
RUN echo "stratum ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/stratum && \
    chmod 0440 /etc/sudoers.d/stratum
RUN echo "gobyte ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/gobyte && \
    chmod 0440 /etc/sudoers.d/gobyte

# Build Yiimp
USER yiimp
WORKDIR "/build"
RUN git clone https://github.com/itayo/yiimp_install_scrypt.git yiimp
WORKDIR "/build/yiimp"
RUN git pull && git checkout origin/docker && ./install.sh	
