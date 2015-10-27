#!/bin/bash
set -e
./scripts/feeds update -a
./scripts/feeds install -a
echo Remove Support for PPPOA
rm ./feeds/luci/protocols/ppp/luasrc/model/cbi/admin_network/proto_pppoa.lua
echo Remove Support for DIR-825 and AllNet Devices
rm ./target/linux/ar71xx/base-files/lib/upgrade/dir825.sh
rm ./target/linux/ar71xx/base-files/lib/upgrade/allnet.sh
        for i in $( ls openwrt-patch ); do
            echo Applying patch $i
            patch -p1 < openwrt-patch/$i
        done
wget http://dl.google.com/closure-compiler/compiler-latest.zip
wget https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.jar
wget http://htmlcompressor.googlecode.com/files/htmlcompressor-1.5.3.jar
unzip -qn compiler-latest.zip
directory=./feeds
for file in $( find $directory -name '*.js' )
do
  echo Compiling $file
  java -jar compiler.jar --warning_level QUIET --compilation_level=SIMPLE_OPTIMIZATIONS --js="$file" --js_output_file="$file-min.js"
  mv -b "$file-min.js" "$file"
done 

for file in $( find $directory -name '*.css' )
do
  echo Minifying $file
  java -jar yuicompressor-2.4.8.jar -o "$file-min.css" "$file"
  mv -b "$file-min.css" "$file"
done

#for file in $( find $directory -name '*.htm' )
#do
#  echo Minifying $file
#  java -jar htmlcompressor-1.5.3.jar -o "$file-min.htm" "$file"
#  mv -b "$file-min.htm" "$file"
#done

#Uncomment 7 lines below to remove L7-Protocol not in used
#echo Update L7 Protocol List
#wget http://download.clearfoundation.com/l7-filter/l7-protocols-2009-05-28.tar.gz
#tar -zxf l7-protocols-2009-05-28.tar.gz
#cp  ./l7-protocols-2009-05-28/protocols/ssh.pat  ./package/network/utils/iptables/files/l7/
#rm  ./package/network/utils/iptables/files/l7/aim.pat
#rm  ./package/network/utils/iptables/files/l7/msnmessenger.pat
#rm  ./package/network/utils/iptables/files/l7/ntp.pat
rm ./target/linux/generic/patches-3.10/063-arm-fix-fiq-vivt.patch
#Comment the lines below to enable L7-Protocol
rm ./target/linux/generic/patches-3.10/600-netfilter_layer7_2.22.patch
rm ./target/linux/generic/patches-3.10/601-netfilter_layer7_pktmatch.patch
rm ./target/linux/generic/patches-3.10/602-netfilter_layer7_match.patch
rm ./target/linux/generic/patches-3.10/603-netfilter_layer7_2.6.36_fix.patch
rm ./package/network/utils/iptables/patches/002-layer7_2.22.patch

make defconfig
rm .config
make defconfig