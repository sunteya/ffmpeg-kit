#!/bin/bash


LIB_NAME="fdk-aac"
SOURCE_DIR="${BASEDIR}/src/${LIB_NAME}"

cd "${SOURCE_DIR}" || return 1
make distclean 2>/dev/null 1>/dev/null

if [[ ! -f ${SOURCE_DIR}/configure ]]; then
  autoreconf_library 1>>"${BASEDIR}"/build.log 2>&1 || return 1
fi

BUILD_DIR="${LIB_INSTALL_BASE}/${LIB_NAME}"
mkdir -p "${BUILD_DIR}"

HOST=$(get_host)

./configure \
  --enable-static \
  --with-pic=yes \
  --disable-shared \
  --prefix="${BUILD_DIR}" \
  --host="${HOST}" || return 1

make -j$(get_cpu_count) || return 1
make install || return 1

cp "${BUILD_DIR}/lib/pkgconfig/fdk-aac.pc" "${INSTALL_PKG_CONFIG_DIR}" || return 1
