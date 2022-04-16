# Scripts to test the Ninja Build xPack

The binaries can be available from one of the pre-releases:

<https://github.com/xpack-dev-tools/pre-releases/releases>

## Download the repo

The test script is part of the Ninja Build xPack:

```sh
rm -rf ${HOME}/Work/meson-build-xpack.git; \
git clone \
  --branch xpack-develop \
  https://github.com/xpack-dev-tools/ninja-build-xpack.git  \
  ${HOME}/Work/ninja-build-xpack.git; \
git -C ${HOME}/Work/ninja-build-xpack.git submodule update --init --recursive
```

## Start a local test

To check if Ninja Build starts on the current platform, run a native test:

```sh
bash ${HOME}/Work/ninja-build-xpack.git/tests/scripts/native-test.sh
```

The script stores the downloaded archive in a local cache, and
does not download it again if available locally.

To force a new download, remove the local archive:

```sh
rm -rf ~/Work/cache/xpack-ninja-build-*-*
```
