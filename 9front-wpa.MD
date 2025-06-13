# Using 9front wifi

## Prerequisites

If you have a 9front-compatible Wi-Fi device (such as the iwn-6005), you need to download firmware from the 9front firmware Git repository:

```
% cd /lib/fimware
% git/clone gits://git.9front.org/plan9front/firmware .
```

Next, compile your kernel source code:

- 386

```
% cd /sys/src/9/pc
% mk install
```

- amd64

```
% cd /sys/src/9/pc64
% mk install
```

- arm32 / Raspberry Pi

```
% cd /sys/src/9/bcm
% mk 'CONF=pi' install
% mk 'CONF=pi2' install
```

- arm64 / Raspberry Pi 3

```
% cd /sys/src/9/bcm64
% mk install
```

Then install the kernel:

- 386

```
% 9fs 9fat
% cp /386/9pc /n/9fat/
```

- amd64

```
% 9fs 9fat
% cp /amd64/9pc64 /n/9fat/
```

If you use an ESP partition:

```
% 9fs esp
% cp /amd64/9pc64 /n/9fat/
```

You may also want to check the complete guide for building source codes on the [FQA](http://fqa.9front.org).

## Using wpa(8)

You should bind your Wi-Fi Ethernet card to ```/net``` and use ```aux/wpa``` to connect to a Wi-Fi station.

To scan your available networks:

```
% cat /net/ether1/ifstats
```

The snippet below is shamelessly stolen from ```wpa(8)``` man page.

```
% bind -a '#l1' /net
% aux/wpa -s ESSID -p /net/ether1
!Adding key: proto=wpapsk essid=ESSID
password: *******
!
% ip/ipconfig ether /net/ether1
```

## Troubleshooting

### Changing ESSID

If you enter the wrong ESSID, you can't just run ```aux/wpa``` again to change it.

You need to terminate ```aux/wpa``` using ```kill(1)```, then restart ```aux/wpa```.

```
% kill wpa
@{echo kill>/proc/xxxx/note} # wpa
% @{echo kill>/proc/xxxx/note} # wpa
% aux/wpa -s CORRECT_ESSID -p /net/ether1
...
```

### Wrong passwords

If you enter the wrong password, delete the key from the ```factotum``` and restarting ```aux/wpa``` as described above.

```
% echo 'delkey proto=wpapsk essid=ESSID'>/mnt/factotum/ctl
...
```

## References

- [FQA](http://fqa.9front.org)
- [9front man page](http://man.9front.org)

