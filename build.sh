#!/bin/bash -e
RSYNC_VER=3.2.3
# Build script to cross-compile rsync for Android
# Copyright © 2020 Matt Robinson

if [ -z "$ANDROID_NDK_HOME" ]; then
    if [ "$ANDROID_HOME" ]; then
        export ANDROID_NDK_HOME=$ANDROID_HOME/ndk-bundle
    else
        echo "Either ANDROID_NDK_HOME or ANDROID_HOME must be set" >&2
        exit 1
    fi
fi

#TARGET=${TARGET:-arm-linux-androideabi}
TARGET=arm-linux-androideabi
PLATFORM=15

toolchain=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64
arm_toolchain=$ANDROID_NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin

mkdir -p rsync-${RSYNC_VER}/build
cd rsync-${RSYNC_VER}/build
#    CC="$toolchain/bin/clang" \
#  -target armv7a-linux-androideabi

../configure --host="$TARGET" --disable-md2man --disable-simd --disable-asm \
    --disable-lz4 --disable-openssl --disable-xxhash --disable-zstd \
    CFLAGS="-target armv7a-linux-androideabi" \
    AR="$arm_toolchain/${TARGET}-ar" \
    CC="$toolchain/bin/clang" \
    LD="$arm_toolchain/${TARGET}-ld" \
    RANLIB="$toolchain/bin/${TARGET}-ranlib" \
    STRIP="$toolchain/bin/${TARGET}-strip"

make
