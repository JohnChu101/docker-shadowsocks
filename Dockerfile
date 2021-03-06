# shadowsocks-net-speeder

FROM ubuntu:14.04.3
MAINTAINER lowid <lowid@outlook.com>
RUN apt-get update && \
    apt-get install -y python-pip libnet1 libnet1-dev libpcap0.8 libpcap0.8-dev git python-m2crypto build-essential wget

RUN pip install shadowsocks

RUN git clone https://github.com/snooda/net-speeder.git net-speeder
WORKDIR net-speeder
RUN sh build.sh

RUN mv net_speeder /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/net_speeder


#install libsodium support chacha20
RUN wget --no-check-certificate -O libsodium-1.0.12.tar.gz https://github.com/jedisct1/libsodium/releases/download/1.0.12/libsodium-1.0.12.tar.gz &&\
    tar zxf libsodium-1.0.12.tar.gz && rm -rf libsodium-1.0.12.tar.gz
WORKDIR libsodium-1.0.12
RUN ./configure && make && make install
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/local.conf
RUN ldconfig

# Configure container to run as an executable
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
