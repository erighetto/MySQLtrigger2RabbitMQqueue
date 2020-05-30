FROM mariadb

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    default-libmysqlclient-dev \
    wget \
    cmake \
    pkg-config \
    libbsd-dev \
    file \
    autoconf \
    libtool \
    nano \
    zip

RUN cd /tmp; \
    wget https://github.com/alanxz/rabbitmq-c/archive/v0.10.0.zip; \
    unzip v0.10.0.zip; \
    ls

RUN cd /tmp/rabbitmq-c-0.10.0; \
    mkdir build && cd build; \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..; \
    cmake --build . --config Release --target install

RUN cd /tmp; \
    wget https://github.com/ssimicro/lib_mysqludf_amqp/archive/master.zip; \
    unzip master.zip; \
    ls

RUN cd /tmp/lib_mysqludf_amqp-master; \
    bash autogen; \
    bash configure; \
    make; \
    make install

RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/local.conf; \
    ldconfig