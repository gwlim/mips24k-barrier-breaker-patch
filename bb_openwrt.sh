#!/bin/bash
set -e
./scripts/feeds update -a
./scripts/feeds install -a
echo -n src-git packagetrunk https://github.com/openwrt/packages.git >> feeds.conf.default
./scripts/feeds update packagetrunk
./scripts/feeds install bcp38
./scripts/feeds install luci-app-bcp38
echo Remove Support for PPPOA
rm ./feeds/luci/protocols/ppp/luasrc/model/cbi/admin_network/proto_pppoa.lua
echo Remove Support for DIR-825 and AllNet Devices
rm ./target/linux/ar71xx/base-files/lib/upgrade/dir825.sh
rm ./target/linux/ar71xx/base-files/lib/upgrade/allnet.sh
        for i in $( ls openwrt-patch ); do
            echo Applying patch $i
            patch -p1 < openwrt-patch/$i
        done
wget https://closure-compiler.googlecode.com/files/compiler-20131014.zip
wget https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.jar
wget http://htmlcompressor.googlecode.com/files/htmlcompressor-1.5.3.jar
unzip -qn compiler-20131014.zip
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

make defconfig
rm .config
make defconfig