#!/usr/bin/env bash
set -euo pipefail

# Build LuaJIT and Android shared library for arm64-v8a on macOS.

# Configure your local Android NDK path and API level.
# Prefer ANDROID_NDK_HOME if set; fallback to the standard SDK path under $HOME.
NDK="${ANDROID_NDK_HOME:-$HOME/Library/Android/sdk/ndk/28.2.13676358}"
API=35

# Detect the correct prebuilt host tag under the NDK (Intel vs Apple Silicon).
HOST_TAG=""
for tag in darwin-arm64 darwin-aarch64 darwin-x86_64; do
  if [ -d "$NDK/toolchains/llvm/prebuilt/$tag" ]; then
    HOST_TAG="$tag"
    break
  fi
done
if [ -z "$HOST_TAG" ]; then
  echo "ERROR: Could not find a valid NDK toolchain under $NDK/toolchains/llvm/prebuilt" >&2
  exit 1
fi

TOOLCHAIN="$NDK/toolchains/llvm/prebuilt/$HOST_TAG"
TRIPLE=aarch64-linux-android
CLANG_CC="$TOOLCHAIN/bin/${TRIPLE}${API}-clang"
LLVM_AR="$TOOLCHAIN/bin/llvm-ar"
LLVM_STRIP="$TOOLCHAIN/bin/llvm-strip"

# Flags for LuaJIT targeting Android arm64
NDKF="--sysroot $TOOLCHAIN/sysroot"
NDKARCH="-DLJ_ABI_SOFTFP=0 -DLJ_ARCH_HASFPU=1 -DLUAJIT_ENABLE_GC64=1 -DLJ_PAGESIZE=16384"

cd luajit-2.1/src
make clean
make \
  HOST_CC="clang -m64" \
  CC="$CLANG_CC" \
  TARGET_SYS=Linux \
  TARGET_FLAGS="$NDKF $NDKARCH" \
  TARGET_AR="$LLVM_AR rcus" \
  TARGET_STRIP="$LLVM_STRIP"

cp ./libluajit.a ../../android/jni/libluajit.a
make clean

cd ../../android
"$NDK/ndk-build" clean APP_ABI="armeabi-v7a,x86,arm64-v8a" APP_PLATFORM=android-${API}
"$NDK/ndk-build" APP_ABI="arm64-v8a" APP_PLATFORM=android-${API}
mkdir -p ../Plugins/Android/libs/arm64-v8a
cp libs/arm64-v8a/libtolua.so ../Plugins/Android/libs/arm64-v8a
"$NDK/ndk-build" clean APP_ABI="armeabi-v7a,x86,arm64-v8a" APP_PLATFORM=android-${API}
