#!/usr/bin/env bash
rm -rf "${HOME}/Downloads/ninja-build-xpack.git"
git clone \
  --recurse-submodules \
  --branch xpack-develop \
  https://github.com/xpack-dev-tools/ninja-build-xpack.git \
  "${HOME}/Downloads/ninja-build-xpack.git"
