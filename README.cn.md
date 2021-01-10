---
title: 基于clash的单网卡路由网关
tags:
  - docker
  - clash
---

[Clash](https://github.com/Dreamacro/clash) 支持VMess, Shadowsocks, Trojan,
Snell 等多种协议, 可以运行在linux, windows, mac等操作系统以及amd64, armv8
等多种硬件架构上。

Quick Reference
===============

- [English version of README](https://github.com/chen-xin/docker_clash/blob/master/README.md) 
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

配置docker的日志大小
---------------------

建议限制docker守护进程的日志大小，否则很容易耗尽磁盘空间。
参考以下代码修改你的`/etc/docker/daemon.json`:

```
{
    "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn/"],
        "log-driver": "json-file",
          "log-opts": {"max-size":"100m", "max-file":"3"}
}
```

创建macvlan:
-----------------------------------

本镜像需要macvlan运行，按需修改以下命令参数：

```
docker network create -d macvlan --subnet=192.168.12.0/24 --gateway=192.168.12.1 --ip-range=192.168.12.64/30 -o parent=eth0 macnet
```

设置windows 10客户端（需要hyper-v)
---------------------------------------------

1. 使用hyper-v管理器创建外部交换机。如果已经有了，则跳过这一步。
2. 使用Powershell（管理员）创建新的虚拟网卡：
```
Add-VMNetworkAdapter -VMName vEthernetStatic2 -SwitchName External
```
3. 设置新虚拟网卡的ip=192.168.12.12, 网关=192.168.12.64(跟上面创建macvlan的相同).
4. 在浏览器(例如firefox), 设置代理为socks5://192.168.12.64:7891（具体按配置）.

Now you can break through the great f*** wall.

