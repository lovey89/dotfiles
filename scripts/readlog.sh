#!/bin/bash

tail "$@" | sed -r '
  s/DEBUG/\x1b[0;34m&\x1b[0m/
  s/INFO/\x1b[0;32m&\x1b[0m/
  s/WARN/\x1b[0;33m&\x1b[0m/
  s/ERROR/\x1b[0;31m&\x1b[0m/'
