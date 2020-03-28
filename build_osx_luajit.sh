#!/bin/bash
# 64 Bit Version
mkdir -p osx

cd luajit-2.1
make clean

make BUILDMODE=static CC="gcc -fPIC -m64 -O2" XCFLAGS=-DLUAJIT_ENABLE_GC64 MACOSX_DEPLOYMENT_TARGET=10.14
cp src/libluajit.a ../osx/libluajit.a
make clean

cd ..

mkdir -p Plugins/osx

gcc -m64 -O2 -std=gnu99 -shared \
 tolua.c \
 int64.c \
 uint64.c \
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
 -Iluajit-2.1/src \
 -Iluasocket \
 -Wl,osx/libluajit.a \