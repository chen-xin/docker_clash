#!/bin/sh

echo "Using Clash version: ${CLASH_VERSION}"

ARCH=$(uname -m)

case $ARCH in
  x86_64)
    TARGET_ARCH=amd64
    ;;
  aarch64)
    TARGET_ARCH=armv8
    ;;
  *)
    echo "unsupported platform"
    exit 123
    ;;
esac

echo "Downloading :[https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb]"
curl -o /clash/Country.mmdb https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb

echo "Downloading :[https://github.com/Dreamacro/clash/releases/download/${CLASH_VERSION}/clash-linux-${TARGET_ARCH}-${CLASH_VERSION}.gz]"
curl -L https://github.com/Dreamacro/clash/releases/download/${CLASH_VERSION}/clash-linux-${TARGET_ARCH}-${CLASH_VERSION}.gz | gzip -d > /clash/clash-linux

chmod +x /clash/clash-linux

ls -al /clash
