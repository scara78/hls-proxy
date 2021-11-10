FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp

RUN \
apt-get update && apt-get upgrade -y && \
apt-get install -y \
unzip \
wget \
tzdata && \
ln -fs /usr/share/zoneinfo/Europe/Stockholm /etc/localtime && \
dpkg-reconfigure --frontend noninteractive tzdata && \
wget -o - https://www.hls-proxy.com/downloads/8.0.1/hls-proxy-8.0.1.linux-x64.zip -O hlsproxy.zip && \
unzip hlsproxy.zip -d /opt/hlsp/ && \
rm hlsproxy.zip && \
apt-get -y remove unzip wget && \
apt-get -yq autoremove && \
rm -rf /var/lib/apt/lists/* && \
chmod +x /opt/hlsp/hls-proxy && \
/opt/hlsp/hls-proxy -address 0.0.0.0 -port 8080 -save -quit

WORKDIR /opt/hlsp
EXPOSE 8080

CMD ["/opt/hlsp/hls-proxy"]
