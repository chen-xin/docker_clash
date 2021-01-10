# docker build . -t chen_x/clash:alpine_armv8
FROM alpine

ARG CN_MIRROR=0
ARG TARGETARCH

RUN if [ $CN_MIRROR=1 ] ; then OS_VER=$(grep main /etc/apk/repositories | sed 's#/#\n#g' | grep "v[0-9]\.[0-9]") \
    && echo "using mirrors for $OS_VER" \
    && echo https://mirrors.ustc.edu.cn/alpine/$OS_VER/main/ > /etc/apk/repositories; fi

RUN apk add --no-cache curl openssl iptables
RUN mkdir -p /clash \
&& echo "#!/bin/sh \n\
iptables -t nat -N CLASH \n\
# Bypass private IP address ranges \n\
iptables -t nat -A CLASH -d 10.0.0.0/8 -j RETURN \n\
iptables -t nat -A CLASH -d 127.0.0.0/8 -j RETURN \n\
iptables -t nat -A CLASH -d 169.254.0.0/16 -j RETURN \n\
iptables -t nat -A CLASH -d 172.16.0.0/12 -j RETURN \n\
iptables -t nat -A CLASH -d 192.168.0.0/16 -j RETURN \n\
iptables -t nat -A CLASH -d 224.0.0.0/4 -j RETURN \n\
iptables -t nat -A CLASH -d 240.0.0.0/4 -j RETURN \n\
# Redirect all TCP traffic to 7892 port, where Clash listens \n\
iptables -t nat -A CLASH -p tcp -j REDIRECT --to-ports 7892 \n\
iptables -t nat -A PREROUTING -p tcp -j CLASH \n\
iptables -t nat -I clash -p tcp -j LOG --log-prefix \"Clash IPT\" \n\
/clash/clash-linux -d /clash"  > /clash/entrypoint.sh \
&& chmod +x /clash/entrypoint.sh

RUN curl -o /clash/Country.mmdb https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb

# RUN CLASH_VERSION=${CLASH_VERSION:-$(curl https://github.com/Dreamacro/clash/tags | grep -o '/Dreamacro/clash/releases/tag/\(v[0-9\.]\+\)' | grep -o 'v[0-9\.]\+' | sort -u | tail -n 1)}\
ARG CLASH_VERSION=v1.3.5
RUN echo "Using Clash version: ${CLASH_VERSION}" \
    && curl -L https://github.com/Dreamacro/clash/releases/download/${CLASH_VERSION}/clash-linux-${TARGETARCH}-${CLASH_VERSION}.gz | gzip -d > /clash/clash-linux\
    && chmod +x /clash/clash-linux

ENTRYPOINT ['/clash/entrypoint.sh']


