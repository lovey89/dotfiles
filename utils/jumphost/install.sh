#!/bin/sh

BASEDIR=$(readlink -f `dirname $0`)
if [ -x "$(command -v dos2unix)" ]; then
  dos2unix ${BASEDIR}/gettunnel
fi
ln -s ${BASEDIR}/gettunnel ~/.ssh/gettunnel

