Custom OpenWrt Patch For Barrier-Breaker TL-WR1043ND
=============================================================

Dependencies
------------

* OpenWRT BuildRoot
* OpenWRT BuildRoot Dependencies
* Java Runtime

How to use
----------

* Install all the development packages required for OpenWrt BuildRoot
* Install Java Runtime
* Clone the Breaker Breaker Repository
```
git clone git://git.openwrt.org/14.07/openwrt.git --depth 1
```
* Clone this Repository and copy into the OpenWRT repository
```
git clone https://github.com/gwlim/mips24k-barrier-breaker-patch.git temp --depth 1; mv temp/* openwrt/; rm -rf temp
```

* Change directory into the OpenWrt Repository
```
cd openwrt
```

* Run the script
```
./bb_openwrt.sh
```
* Make Menuconfig and select the Target Profile TP-LINK TL-WR1043ND (all the packages and config is inside except build target
```
make menuconfig
```
* Save and make
```
make V=s
```


