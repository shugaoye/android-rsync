#!/bin/bash
#
# build_android.sh - build rsync binaries for different mobile architectures using the Android NDK
#
# Florian Dejonckheere <florian@floriandejonckheere.be>
#

# Whether or not to strip binaries (smaller filesize)
STRIP=1
API=14
GCC=4.9
RSYNC_VER=3.2.3
RSYNC_PKG=rsync-${RSYNC_VER}.tar.gz
RSYNC_URL=https://download.samba.org/pub/rsync/src/${RSYNC_PKG}
SYSPREFIX="${ANDROID_NDK_HOME}/platforms/android-${API}/arch-"
ARCH=(arm x86 mips)
PREFIX=(arm-linux-androideabi-  x86- mipsel-linux-android-)
CCPREFIX=(arm-linux-androideabi- i686-linux-android- mipsel-linux-android-)

if [ -z $ANDROID_NDK_HOME ]; then
        echo ANDROID_NDK_HOME is empty.
		exit
else
        echo ANDROID_NDK_HOME=${ANDROID_NDK_HOME}
fi

if [ -d rsync-${RSYNC_VER} ]; then
        echo Found folder rsync
else
	if [ -f ${RSYNC_PKG} ]; then
		tar xvfz ${RSYNC_PKG}
	else
		curl ${RSYNC_URL} --output ${RSYNC_PKG}
		tar xvfz ${RSYNC_PKG}
		exit
	fi
fi

mkdir -p rsync-${RSYNC_VER}/build
cd rsync-${RSYNC_VER}/build
for I in $(seq 0 $((${#ARCH[@]} - 1))); do
	mkdir -p ${ARCH[$I]}
	cd ${ARCH[$I]}
	#make clean
	export CC="${ANDROID_NDK_HOME}/toolchains/${PREFIX[$I]}${GCC}/prebuilt/linux-x86_64/bin/${CCPREFIX[$I]}gcc --sysroot=${SYSPREFIX}${ARCH[$I]}"
	../../configure CFLAGS="-static" --host="${ARCH[$I]}" \
	 --disable-md2man --disable-simd --disable-asm \
    --disable-lz4 --disable-openssl --disable-xxhash --disable-zstd
	make
	(( $STRIP )) && ${ANDROID_NDK_HOME}/toolchains/${PREFIX[$I]}${GCC}/prebuilt/linux-x86_64/bin/${CCPREFIX[$I]}strip rsync
	mv rsync "rsync-${ARCH[$I]}"
	cd ..
done

echo -en "\e[1;33m"
for I in $(seq 0 $((${#ARCH[@]} - 1))); do
	file "${ARCH[$I]}/rsync-${ARCH[$I]}"
done
echo -en "\e[0m"
