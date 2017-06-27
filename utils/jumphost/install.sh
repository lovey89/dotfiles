#!/bin/sh

BASEDIR=$(readlink -f `dirname $0`)

ln -s ${BASEDIR}/getdb ~/.ssh/getdb

