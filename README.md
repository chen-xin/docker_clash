---
title: Router service on single-NIC linux box with Dreamacro/clash
tags:
  - docker
  - clash
---

[Clash](https://github.com/Dreamacro/clash) support VMess, Shadowsocks, Trojan,
Snell protocol for remote connections, can run on linux, windows, mac on various
hardware architectures, is popular and under active developing recently. 

Quick Reference
===============

- [中文版](https://github.com/chen-xin/docker_clash/blob/master/README.cn.md)
- [Clash](https://github.com/Dreamacro/clash)


Supported tags and respective Dockerfile links
===================================================

- [v0.19.0](https://github.com/chen-xin/docker_clash/blob/d32573ead0594f171a3475c57f4f948ef2fcac1c/Dockerfile.debian), [latest](https://github.com/chen-xin/docker_clash/blob/d32573ead0594f171a3475c57f4f948ef2fcac1c/Dockerfile.debian), [v0.19.0-alpine](https://github.com/chen-xin/docker_clash/blob/d32573ead0594f171a3475c57f4f948ef2fcac1c/Dockerfile.alpine), [latest-alpine](https://github.com/chen-xin/docker_clash/blob/d32573ead0594f171a3475c57f4f948ef2fcac1c/Dockerfile.alpine)

Other Reference
===============

- [docker 中运行 openwrt](https://github.com/lisaac/openwrt-in-docker)
- another[docker 运行 openwrt](https://github.com/luoqeng/OpenWrt-on-Docker)
- [Use macvlan networks](https://docs.docker.com/network/macvlan/)
- [斐讯N1 – 完美刷机Armbian教程](https://yuerblog.cc/2019/10/23/%e6%96%90%e8%ae%afn1-%e5%ae%8c%e7%be%8e%e5%88%b7%e6%9c%baarmbian%e6%95%99%e7%a8%8b/)
- [N1刷Armbian系统并在Docker中安装OpenWrt旁路由的详细教程](https://www.right.com.cn/forum/thread-1347921-1-1.html)
- [N1盒子做旁路由刷OpenWRT系统（小白专用）](https://www.cnblogs.com/neobuddy/p/n1-setup.html)
- [Docker上运行Lean大源码编译的OpenWRT（初稿）](https://openwrt.club/93.html)
- [engineerlzk 的CSDN博客](https://me.csdn.net/engineerlzk)
- [我在用的armbian版本](https://github.com/kuoruan/Build-Armbian/releases/tag/v5.99-20200408)

How to use this image
===============

Config docker log
---------------------

It's recommended to limit docker daemon's log size, or you will soon runout of disk space.
Modify your `/etc/docker/daemon.json` like the following:

```
{
    "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn/"],
        "log-driver": "json-file",
          "log-opts": {"max-size":"100m", "max-file":"3"}
}
```

Create macvlan network for docker:
-----------------------------------

This image needs macvlan to function properly, modify the below sample to fit your needs.

```
docker network create -d macvlan --subnet=192.168.12.0/24 --gateway=192.168.12.1 --ip-range=192.168.12.64/30 -o parent=eth0 macnet
```

Setup windows 10 client to use the gateway(optional)
---------------------------------------------

1. Create new external switch with hyper-v manager if there is no existing one.
2. Create new vEthernet adapater with powershell(admin):
```
Add-VMNetworkAdapter -VMName vEthernetStatic2 -SwitchName External
```
3. Set the new adapater's ip=192.168.12.12, gateway=192.168.12.64(ip of clash container).
4. In browser(firefox), set proxy to socks5://192.168.12.64:7891(as macvlan config)

Now you can break through the great f*** wall.
