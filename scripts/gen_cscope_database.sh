#!/bin/bash

# Top directory of project whose source code is to be indexed.
src=$1

if [ -r ${src}/cscope.files ]; then
    rm ${src}/cscope.files
fi

echo -n "Start find command:   "
date +%T

find ${src} \
  \( ! -name ".git" -a ! \
       -path "./path/to/ignore" -o -prune \) \
   -name "*.[chxsS]" -type f -print -or -name "*.cpp" -type f -print > ${src}/cscope.files

echo -n "Start cscope command: "
date +%T

if [ -r ${src}/cscope.files ]; then
    cd ${src}
    cscope -b -q -k
fi

echo -n "Done:                 "
date +%T
