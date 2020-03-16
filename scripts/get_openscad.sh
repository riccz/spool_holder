#!/bin/sh

set -eux

OPENSCAD_VERSION="2019.05"
OPENSCAD_SHA256="3d3176b10ce8bd136950fa36061f824eee5ffa23cdf5dd91bcf89f5ece6f2592"

sudo apt-get update
sudo apt-get install -y \
    curl \
    libfontconfig \
    libharfbuzz-bin \
    xvfb

OPENSCAD_APPIMAGE="OpenSCAD-${OPENSCAD_VERSION}-x86_64.AppImage"

curl -sSLo "${OPENSCAD_APPIMAGE}" "https://files.openscad.org/${OPENSCAD_APPIMAGE}"
echo "${OPENSCAD_SHA256}  ${OPENSCAD_APPIMAGE}" | sha256sum -c -

chmod a+x "${OPENSCAD_APPIMAGE}"
"./${OPENSCAD_APPIMAGE}" --appimage-extract

ln -s "squashfs-root/usr/bin/openscad" openscad

