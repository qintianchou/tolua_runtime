#!/bin/bash
# 64 Bit Version
mkdir -p window/x86_64

cd lua-5.1.5
make clean

make mingw CC="gcc -m64"
cp src/liblua.a ../window/x86_64/liblua.a
make clean

cd ..

gcc -m64 -O2 -std=gnu99 -shared \
 tolua.c \
 int64.c \
 uint64.c \
 bit.c \
 pb.c \
 lpeg.c \
 struct.c \
 cjson/strbuf.c \
 cjson/lua_cjson.c \
 cjson/fpconv.c \
 luasocket/auxiliar.c \
 luasocket/buffer.c \
 luasocket/except.c \
 luasocket/inet.c \
 luasocket/io.c \
 luasocket/luasocket.c \
 luasocket/mime.c \
 luasocket/options.c \
 luasocket/select.c \
 luasocket/tcp.c \
 luasocket/timeout.c \
 luasocket/udp.c \
 luasocket/wsocket.c \
 -o Plugins/x86_64/tolua.dll \
 -I./ \
 -Ilua-5.1.5/src \
 -Iluasocket \
 -lws2_32 \
 -Wl,--whole-archive window/x86_64/liblua.a \
 -Wl,--no-whole-archive -static-libgcc -static-libstdc++