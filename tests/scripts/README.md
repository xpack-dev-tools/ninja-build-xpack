# Scripts to test the Ninja Build xPack

The binaries can be available from one of the pre-releases:

https://github.com/xpack-dev-tools/pre-releases/releases

## Download the repo

The test script is part of the Ninja Build xPack:

```bash
rm -rf ~/Downloads/opencod-xpack.git
git clone --recurse-submodules -b xpack-develop \
  https://github.com/xpack-dev-tools/ninja-build-xpack.git  \
  ~/Downloads/ninja-build-xpack.git
```

## Start a local test

To check if OpenCOD starts on the current platform, run a native test:

```bash
bash ~/Downloads/ninja-build-xpack.git/tests/scripts/native-test.sh
```

The script stores the downloaded archive in a local cache, and
does not download it again if available locally.

To force a new download, remove the local archive:

```console
rm ~/Work/cache/xpack-ninja-build-*
```

## Start the Travis test

The multi-platform test runs on Travis CI; it is configured to not fire on
git actions, but only via a manual POST to the Travis API.

```bash
bash ~/Downloads/ninja-build-xpack.git/tests/scripts/travis-trigger.sh
```

For convenience, on macOS this can be invoked from Finder, using
the `travis-trigger.mac.command` shortcut.
