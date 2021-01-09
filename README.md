Clash service on docker on single-NIC linux box(PhicommN1)
===================================================

[Clash](https://github.com/Dreamacro/clash) support VMess, Shadowsocks, Trojan,
Snell protocol for remote connections, can run on linux, windows, mac on various
hardware architectures, is popular and under active developing recently. 

PhicommN1 is an arm box with 2GB ram, 8GB emmc and 1000M lan,
fair enough for a low power consuming server.
I got 2 from PinDuodou for about rmb120 each.

Setup
-----

### On PhicommN1

1. Flash armbian into PhicommN1.

2. Install docker.

Remember to set docker daemon log size, or you will soon runout of disk space.
In my case, `/etc/docker/daemon.json` is like the following:
```
{
    "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn/"],
        "log-driver": "json-file",
          "log-opts": {"max-size":"100m", "max-file":"3"}
}
```
2. Create macvlan network for docker:
```
docker network create -d macvlan --subnet=192.168.12.0/24 --gateway=192.168.12.1 --ip-range=192.168.12.64/30 -o parent=eth0 macnet
```
3. Run `docker-compose -f docker-compose.unmanaged.yml up -d`

### On client(Windows 10 with hyper-v)

1. Create new external switch with hyper-v manager if there is no existing one.
2. Create new vEthernet adapater with powershell(admin):
```
Add-VMNetworkAdapter -VMName vEthernetStatic2 -SwitchName External
```
3. Set the new adapater's ip=192.168.12.12, gateway=192.168.12.64(ip of clash container).
4. In browser(firefox), set proxy to socks5://192.168.12.64:7891(as macvlan config)

Now you can break through the great f*** wall.

Managed vs ummanaged
---------------------

In this note, managed means you have authorith to change your local network settings, e.g. in your home network,
unmanaged means you cannot do any change to your lan, e.g. in your office and your are not admin.

use appropriate compose file to meet your requirements.


