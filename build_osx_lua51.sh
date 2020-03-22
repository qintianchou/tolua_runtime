#!/bin/bash
# 64 Bit Version
mkdir -p osx

cd lua-5.1.5
make clean

make macosx CC="gcc -m64"
cp src/liblua.a ../osx/liblua.a
make clean

cd ..

mkdir -p Plugins/osx

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
 luasocket/usocket.c \
 -o Plugins/osx/libtolua.dylib \
 -I./ \
 -Ilua-5.1.5/src \
 -Iluasocket \
 -Wl,osx/liblua.a \