FROM mariadb

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    default-libmysqlclient-dev \
    wget \
    zip

RUN cd /tmp; \
    wget https://github.com/mysqludf/lib_mysqludf_sys/archive/master.zip; \
    unzip master.zip; \
    ls

RUN cd /tmp/lib_mysqludf_sys-master; \
    ls; \
    sed -i '$ d' Makefile; \
    echo '	gcc -DMYSQL_DYNAMIC_PLUGIN -fPIC -Wall -m64 -I/usr/include/mysql -I. -shared lib_mysqludf_sys.c -o lib_mysqludf_sys.so' >> Makefile; \
    cat Makefile; \
    make install; \
    cp lib_mysqludf_sys.so /usr/lib/mysql/plugin/

COPY bin opt

RUN chmod 775 /opt/pubmess.sh