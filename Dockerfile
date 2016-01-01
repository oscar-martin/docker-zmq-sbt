FROM oscarmartin/zmqbase
MAINTAINER oscarmartinvicente@gmail.com

# Install 
RUN apt-get update && apt-get install -y apt-transport-https \
    && echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823 \
    && apt-get update && apt-get install -y --fix-missing \
    openjdk-7-jre-headless \
    openjdk-7-jdk \
    libtool \
    pkg-config \
    build-essential \
    autoconf \
    automake \
    git \
    sbt \
    && ln -s /usr/bin/libtoolize /usr/bin/libtool \
    && mkdir -p /tmp/zeromq \
    && cd /tmp/zeromq \
    && git clone https://github.com/zeromq/jzmq.git \
    && cd jzmq \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && rm -rf /tmp/zeromq \
    && apt-get purge -y libtool \
    pkg-config \
    build-essential \
    git \
    autoconf \
    automake \
    locales \
    manpages \
    manpages-dev \
    perl \
    gcc \
    python \
    && apt-get clean && apt-get autoclean && apt-get -y autoremove

VOLUME /project
WORKDIR /project

# The installation process will set shared objects (libraries) in /usr/local/lib
ENTRYPOINT ["sbt", "-Djava.library.path=/usr/local/lib"]
