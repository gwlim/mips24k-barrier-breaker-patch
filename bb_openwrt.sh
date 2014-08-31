#!/bin/bash
./scripts/feeds update -a
./scripts/feeds install -a
rm ./feeds/luci/protocols/ppp/luasrc/model/cbi/admin_network/proto_pppoa.lua
        for i in $( ls openwrt-patch ); do
            echo Applying patch $i
            patch -p1 < openwrt-patch/$i
        done
wget https://closure-compiler.googlecode.com/files/compiler-20131014.zip
wget https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.jar
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
make defconfig
rm .config
make defconfig