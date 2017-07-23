# shadowsocks-net-speeder

FROM ubuntu:14.04.3
MAINTAINER lowid <lowid@outlook.com>
RUN apt-get update && \
    apt-get install -y python-pip libnet1 libnet1-dev libpcap0.8 libpcap0.8-dev git python-m2crypto build-essential curl

RUN pip install shadowsocks

RUN git clone https://github.com/snooda/net-speeder.git net-speeder
WORKDIR net-speeder
RUN sh build.sh

RUN mv net_speeder /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/net_speeder


RUN \
    mkdir -p /tmpbuild/libsodium && \
    cd /tmpbuild/libsodium && \
    curl -L https://download.libsodium.org/libsodium/releases/libsodium-1.0.11.tar.gz -o libsodium-1.0.11.tar.gz && \
    tar xfvz libsodium-1.0.11.tar.gz && \
    cd /tmpbuild/libsodium/libsodium-1.0.11/ && \
    ./configure && \
    make && make check && \
    make install && \
	echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
	ldconfig
#    mv src/libsodium /usr/local/ && \
    rm -Rf /tmpbuild/

# Configure container to run as an executable
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
