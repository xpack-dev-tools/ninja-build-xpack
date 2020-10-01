# How to build the xPack Ninja Build?

## Introduction

This project also includes the scripts and additional files required to
build and publish the
[xPack Ninja Build](https://github.com/xpack-dev-tools/ninja-build-xpack) binaries.

The build scripts use the
[xPack Build Box (XBB)](https://github.com/xpack/xpack-build-box),
a set of elaborate build environments based on recent GCC versions
(Docker containers
for GNU/Linux and Windows or a custom folder for MacOS).

## Repositories

- `https://github.com/xpack-dev-tools/ninja-build-xpack.git` - the URL of the
  [xPack Ninja Build fork](https://github.com/xpack-dev-tools/ninja-build-xpack)
- `https://github.com/xpack-dev-tools/build-helper` - the URL of the
  xPack build helper, used as the `scripts/helper` submodule.
- `https://github.com/ninja-build/ninja` - the URL of the original Ninja repo

### Branches

- `xpack` - the updated content, used during builds
- `xpack-develop` - the updated content, used during development
- `master` - empty

## Prerequisites

The prerequisites are common to all binary builds. Please follow the
instructions in the separate
[Prerequisites for building binaries](https://xpack.github.io/xbb/prerequisites/)
page and return when ready.

## Download the build scripts

The build scripts are available in the `scripts` folder of the
[`xpack-dev-tools/ninja-build-xpack`](https://github.com/xpack-dev-tools/ninja-build-xpack)
Git repo.

To download them, the following shortcut is available:

```console
$ curl -L https://github.com/xpack-dev-tools/ninja-build-xpack/raw/xpack/scripts/git-clone.sh | bash
```

This small script issues the following two commands:

```console
$ rm -rf ~/Downloads/ninja-build-xpack.git
$ git clone --recurse-submodules \
  https://github.com/xpack-dev-tools/ninja-build-xpack.git \
  ~/Downloads/ninja-build-xpack.git
```

> Note: the repository uses submodules; for a successful build it is
> mandatory to recurse the submodules.

For development purposes, there is a shortcut to clone the `xpack-develop`
branch:

```console
$ curl -L https://github.com/xpack-dev-tools/ninja-build-xpack/raw/xpack/scripts/git-clone-develop.sh | bash
```

which is a shortcut for:

```console
$ rm -rf ~/Downloads/ninja-build-xpack.git
$ git clone --recurse-submodules --branch xpack-develop \
  https://github.com/xpack-dev-tools/ninja-build-xpack.git \
  ~/Downloads/ninja-build-xpack.git
```

## The `Work` folder

The scripts create a temporary build `Work/ninja-build-${version}` folder in
the user home. Although not recommended, if for any reasons you need to
change the location of the `Work` folder,
you can redefine `WORK_FOLDER_PATH` variable before invoking the script.

## Changes

Compared to the original Ninja Build distribution, there should be no
functional changes.

The actual changes for each version are documented in the
`scripts/README-<version>.md` files.

## How to build local/native binaries

### README-DEVELOP.md

The details on how to prepare the development environment for Ninja Build are in the
[`README-DEVELOP.md`](https://github.com/xpack-dev-tools/ninja-build-xpack/blob/xpack/README-DEVELOP.md) file.

## How to build distributions

### Update git repos

To keep the development repository in sync with the original Ninja Build
repository, in the `xpack-dev-tools/ninja-build` Git repo:

- checkout `xpack`
- merge `xpack-develop`

No need to add a tag here, it'll be added when the release is created.

### Prepare release

To prepare a new release, first determine the Ninja Build version
(like `1.10.0`) and update the `scripts/VERSION` file. The format is
`1.10.0-1`. The fourth number is the xPack release number
of this version. A fifth number will be added when publishing
the package on the `npm` server.

Add a new set of definitions in the `scripts/container-build.sh`, with
the versions of various components.

### Check `README.md`

Normally `README.md` should not need changes, but better check.
Information related to the new version should not be included here,
but in the version specific file (below).

### Create `README-<version>.md`

In the `scripts` folder create a copy of the previous one and update the
Git commit and possible other details.

### Update `CHANGELOG.md`

Check `CHANGELOG.md` and add the new release.

### Build

Although it is perfectly possible to build all binaries in a single step
on a macOS system, due to Docker specifics, it is faster to build the
GNU/Linux and Windows binaries on a GNU/Linux system and the macOS binary
separately on a macOS system.

#### Build the Intel GNU/Linux and Windows binaries

The current platform for GNU/Linux and Windows production builds is an
Manjaro 19, running on an Intel NUC8i7BEH mini PC with 32 GB of RAM
and 512 GB of fast M.2 SSD.

```console
$ ssh xbbi
```

Before starting a build, check if Docker is started:

```console
$ docker info
```

Before running a build for the first time, it is recommended to preload the
docker images.

```console
$ bash ~/Downloads/ninja-build-xpack.git/scripts/build.sh preload-images
```

The result should look similar to:

```console
$ docker images
REPOSITORY          TAG                              IMAGE ID            CREATED             SIZE
ilegeul/ubuntu      i386-12.04-xbb-v3.2              fadc6405b606        2 days ago          4.55GB
ilegeul/ubuntu      amd64-12.04-xbb-v3.2             3aba264620ea        2 days ago          4.98GB
hello-world         latest                           bf756fb1ae65        5 months ago        13.3kB
```

Since the build takes a while, use `screen` to isolate the build session
from unexpected events, like a broken
network connection or a computer entering sleep.

```console
$ screen -S ninja

$ sudo rm -rf ~/Work/ninja-build-*
$ bash ~/Downloads/ninja-build-xpack.git/scripts/build.sh --all
```

or, for development builds:

```console
$ bash ~/Downloads/ninja-build-xpack.git/scripts/build.sh --linux64 --linux32 --win64 --win32 --develop
```

To detach from the session, use `Ctrl-a` `Ctrl-d`; to reattach use
`screen -r ninja-build`; to kill the session use `Ctrl-a` `Ctrl-k` and confirm.

A few minutes later, the output of the build script is a set of 4
archives and their SHA signatures, created in the `deploy` folder:

```console
$ ls -l ~/Work/ninja-build-*/deploy
total 1624
-rw-rw-r-- 1 ilg ilg 233764 Sep 28 16:53 xpack-ninja-build-1.10.0-1-linux-x32.tar.gz
-rw-rw-r-- 1 ilg ilg    110 Sep 28 16:53 xpack-ninja-build-1.10.0-1-linux-x32.tar.gz.sha
-rw-rw-r-- 1 ilg ilg 217440 Sep 28 16:52 xpack-ninja-build-1.10.0-1-linux-x64.tar.gz
-rw-rw-r-- 1 ilg ilg    110 Sep 28 16:52 xpack-ninja-build-1.10.0-1-linux-x64.tar.gz.sha
-rw-rw-r-- 1 ilg ilg 475368 Sep 28 16:53 xpack-ninja-build-1.10.0-1-win32-x32.zip
-rw-rw-r-- 1 ilg ilg    107 Sep 28 16:53 xpack-ninja-build-1.10.0-1-win32-x32.zip.sha
-rw-rw-r-- 1 ilg ilg 706151 Sep 28 16:52 xpack-ninja-build-1.10.0-1-win32-x64.zip
-rw-rw-r-- 1 ilg ilg    107 Sep 28 16:52 xpack-ninja-build-1.10.0-1-win32-x64.zip.sha
```

To copy the files from the build machine to the current development
machine, either use NFS to mount the entire folder, or open the `deploy`
folder in a terminal and use `scp`:

```console
$ (cd ~/Work/ninja-build-*/deploy; scp * ilg@wks:Downloads/xpack-binaries/ninja)
```

#### Build the Arm GNU/Linux binaries

The current platform for GNU/Linux and Windows production builds is an
Manjaro 19, running on an Raspberry Pi 4B with 4 GB of RAM
and 256 GB of fast M.2 SSD.

```console
$ ssh xbba
```

Before starting a build, check if Docker is started:

```console
$ docker info
```

Before running a build for the first time, it is recommended to preload the
docker images.

```console
$ bash ~/Downloads/ninja-build-xpack.git/scripts/build.sh preload-images
```

The result should look similar to:

```console
$ docker images
REPOSITORY          TAG                                IMAGE ID            CREATED             SIZE
ilegeul/ubuntu      arm32v7-16.04-xbb-v3.2             b501ae18580a        27 hours ago        3.23GB
ilegeul/ubuntu      arm64v8-16.04-xbb-v3.2             db95609ffb69        37 hours ago        3.45GB
hello-world         latest                             a29f45ccde2a        5 months ago        9.14kB
```

Since the build takes a while, use `screen` to isolate the build session
from unexpected events, like a broken
network connection or a computer entering sleep.

```console
$ screen -S ninja

$ sudo rm -rf ~/Work/ninja-build-*
$ bash ~/Downloads/ninja-build-xpack.git/scripts/build.sh --all
```

To detach from the session, use `Ctrl-a` `Ctrl-d`; to reattach use
`screen -r ninja`; to kill the session use `Ctrl-a` `Ctrl-k` and confirm.

A few minutes later, the output of the build script is a set of 2
archives and their SHA signatures, created in the `deploy` folder:

```console
$ ls -l ~/Work/ninja-build-*/deploy
total 416
-rw-rw-r-- 1 ilg ilg 215309 Sep 28 14:00 xpack-ninja-build-1.10.0-1-linux-arm64.tar.gz
-rw-rw-r-- 1 ilg ilg    112 Sep 28 14:00 xpack-ninja-build-1.10.0-1-linux-arm64.tar.gz.sha
-rw-rw-r-- 1 ilg ilg 199196 Sep 28 14:01 xpack-ninja-build-1.10.0-1-linux-arm.tar.gz
-rw-rw-r-- 1 ilg ilg    110 Sep 28 14:01 xpack-ninja-build-1.10.0-1-linux-arm.tar.gz.sha
```

To copy the files from the build machine to the current development
machine, either use NFS to mount the entire folder, or open the `deploy`
folder in a terminal and use `scp`:

```console
$ (cd ~/Work/ninja-build-*/deploy; scp * ilg@wks:Downloads/xpack-binaries/ninja)
```

#### Build the macOS binary

The current platform for macOS production builds is a macOS 10.10.5
running on a MacBook Pro with 32 GB of RAM and a fast SSD.

```console
$ ssh xbbm
```

To build the latest macOS version:

```console
$ screen -S ninja

$ rm -rf ~/Work/ninja-build-*
$ caffeinate bash ~/Downloads/ninja-build-xpack.git/scripts/build.sh --osx
```

To detach from the session, use `Ctrl-a` `Ctrl-d`; to reattach use
`screen -r ninja`; to kill the session use `Ctrl-a` `Ctrl-\` or
`Ctrl-a` `Ctrl-k` and confirm.

Several moments later, the output of the build script is a compressed
archive and its SHA signature, created in the `deploy` folder:

```console
$ ls -l ~/Work/ninja-build-*/deploy
total 1768
-rw-r--r--  1 ilg  staff  900060 Sep 28 17:04 xpack-ninja-build-1.10.0-1-darwin-x64.tar.gz
-rw-r--r--  1 ilg  staff     111 Sep 28 17:04 xpack-ninja-build-1.10.0-1-darwin-x64.tar.gz.sha
```

To copy the files from the build machine to the current development
machine, either use NFS to mount the entire folder, or open the `deploy`
folder in a terminal and use `scp`:

```console
$ (cd ~/Work/ninja-build-*/deploy; scp * ilg@wks:Downloads/xpack-binaries/ninja)
```

### Subsequent runs

#### Separate platform specific builds

Instead of `--all`, you can use any combination of:

```
--win32 --win64 --linux32 --linux64
--arm --arm64
```

#### `clean`

To remove most build temporary files, use:

```console
$ bash ~/Downloads/ninja-build-xpack.git/scripts/build.sh --all clean
```

To also remove the library build temporary files, use:

```console
$ bash ~/Downloads/ninja-build-xpack.git/scripts/build.sh --all cleanlibs
```

To remove all temporary files, use:

```console
$ bash ~/Downloads/ninja-build-xpack.git/scripts/build.sh --all cleanall
```

Instead of `--all`, any combination of `--win32 --win64 --linux32 --linux64`
will remove the more specific folders.

For production builds it is recommended to completely remove the build folder.

#### `--develop`

For performance reasons, the actual build folders are internal to each
Docker run, and are not persistent. This gives the best speed, but has
the disadvantage that interrupted builds cannot be resumed.

For development builds, it is possible to define the build folders in
the host file system, and resume an interrupted build.

#### `--debug`

For development builds, it is also possible to create everything with
`-g -O0` and be able to run debug sessions.

#### Interrupted builds

The Docker scripts run with root privileges. This is generally not a
problem, since at the end of the script the output files are reassigned
to the actual user.

However, for an interrupted build, this step is skipped, and files in
the install folder will remain owned by root. Thus, before removing
the build folder, it might be necessary to run a recursive `chown`.

## Test

A simple test is performed by the script at the end, by launching the
executable to check if all shared/dynamic libraries are correctly used.

For a true test you need to unpack the archive in a temporary location
(like `~/Downloads`) and then run the
program from there. For example on macOS the output should
look like:

```console
$ /Users/ilg/Downloads/xPacks/ninja-build/1.10.0-1/bin/ninja --version
1.10.0
```

## Installed folders

After install, the package should create a structure like this (macOS files;
only the first two depth levels are shown):

```console
$ tree -L 2 /Users/ilg/Library/xPacks/\@xpack-dev-tools/ninja-build/1.10.0-1.1/.content/
/Users/ilg/Library/xPacks/\@xpack-dev-tools/ninja-build/1.10.0-1.1/.content/
├── README.md
├── bin
│   ├── libgcc_s.1.dylib
│   ├── libstdc++.6.dylib
│   └── ninja
└── distro-info
    ├── CHANGELOG.md
    ├── licenses
    ├── patches
    └── scripts

5 directories, 5 files
```

No other files are installed in any system folders or other locations.

## Uninstall

The binaries are distributed as portable archives; thus they do not need
to run a setup and do not require an uninstall; simply removing the
folder is enough.

## Files cache

The XBB build scripts use a local cache such that files are downloaded only
during the first run, later runs being able to use the cached files.

However, occasionally some servers may not be available, and the builds
may fail.

The workaround is to manually download the files from an alternate
location (like
https://github.com/xpack-dev-tools/files-cache/tree/master/libs),
place them in the XBB cache (`Work/cache`) and restart the build.

## More build details

The build process is split into several scripts. The build starts on
the host, with `build.sh`, which runs `container-build.sh` several
times, once for each target, in one of the two docker containers.
Both scripts include several other helper scripts. The entire process
is quite complex, and an attempt to explain its functionality in a few
words would not be realistic. Thus, the authoritative source of details
remains the source code.
