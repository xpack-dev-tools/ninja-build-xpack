---

title:  xPack Ninja Build v1.10.2-4 released
sidebar: ninja-build

summary: "Version **1.10.2-4** is a maintenance release; it is a rebuild with the latest build environment."

version: 1.10.2-4
npm_subversion: 1

download_url: https://github.com/xpack-dev-tools/ninja-build-xpack/releases/tag/v1.10.2-4/

date: 2021-10-19 14:44:57 +0300

redirect_to: https://xpack-dev-tools.github.io/ninja-build-xpack/blog/2021/10/19/ninja-build-v1-10-2-4-released/

comments: true

categories:
  - releases
  - ninja-build

tags:
  - releases
  - ninja-build
  - ninja
  - build
  - speed
  - small

---

The [xPack Ninja Build](https://xpack.github.io/dev-tools/ninja-build/)
is a standalone cross-platform binary distribution of
[Ninja Build](https://ninja-build.org).

There are separate binaries for **Windows** (x64 and x86),
**macOS** (x64) and **GNU/Linux** (x64 and x86, arm64 and arm).

{% include note.html content="The main targets for the GNU/Linux Arm
binaries are the **Raspberry Pi** class devices (armv7l and aarch64;
armv6 is not supported)." %}

## Download

The binary files are available from [GitHub Releases]({{ page.download_url }}).

## Prerequisites

- x86/x64 GNU/Linux: any system with **GLIBC 2.15** or higher
  (like Ubuntu 12 or later, Debian 8 or later, RedHat/CentOS 7 later,
  Fedora 20 or later, etc)
- arm64/arm GNU/Linux: any system with **GLIBC 2.23** or higher
  (like Ubuntu 16 or later, Debian 9 or later, RedHat/CentOS 8 or later,
  Fedora 24 or later, etc)
- x86/x64 Windows: Windows 7 with the Universal C Runtime
  ([UCRT](https://support.microsoft.com/en-us/topic/update-for-universal-c-runtime-in-windows-c0514201-7fe6-95a3-b0a5-287930f3560c)),
  Windows 8, Windows 10
- x64 macOS: 10.13 or later

## Install

The full details of installing the **xPack Ninja Build** on various platforms
are presented in the separate [Install]({{ site.baseurl }}/dev-tools/ninja-build/install/) page.

### Easy install

The easiest way to install Ninja Build is with
[`xpm`]({{ site.baseurl }}/xpm/)
by using the **binary xPack**, available as
[`@xpack-dev-tools/ninja-build`](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build)
from the [`npmjs.com`](https://www.npmjs.com) registry.

With the `xpm` tool available, installing
the latest version of the package and adding it as
a dependency for a project is quite easy:

```sh
cd my-project
xpm init # Only at first use.

xpm install @xpack-dev-tools/ninja-build@latest

ls -l xpacks/.bin
```

To install this specific version, use:

```sh
xpm install @xpack-dev-tools/ninja-build@{{ page.version }}.{{ page.npm_subversion }}
```

It is also possible to install Meson Build globally, in the user home folder,
but this requires xPack aware tools to automatically identify them and
manage paths.

```sh
xpm install --global @xpack-dev-tools/ninja-build@latest --verbose
```

### Uninstall

To remove the links from the current project:

```sh
cd my-project

xpm uninstall @xpack-dev-tools/ninja-build
```

To completely remove the package from the central xPacks store:

```sh
xpm uninstall --global @xpack-dev-tools/ninja-build
```

## Compliance

The xPack Ninja Build generally follows the official
[Ninja Build](https://ninja-build.org) releases.

The current version is based on:

- Ninja release
[1.10.2](https://github.com/ninja-build/ninja/releases/tag/v1.10.2)
from Nov 28th, 2020.

## Changes

Compared to the upstream version, the Windows version also supports
spawning scripts via `cmd.exe /c`. These scripts are used by **npm**/**xpm**
to redirect invocations to the central packages repository.

## Bug fixes

- none

## Enhancements

- none

## Known problems

- none

## Shared libraries

On all platforms the packages are standalone, and expect only the standard
runtime to be present on the host.

All dependencies that are build as shared libraries are copied locally
in the `libexec` folder (or in the same folder as the executable for Windows).

### `DT_RPATH` and `LD_LIBRARY_PATH`

On GNU/Linux the binaries are adjusted to use a relative path:

```console
$ readelf -d library.so | grep runpath
 0x000000000000001d (RPATH)            Library rpath: [$ORIGIN]
```

In the GNU ld.so search strategy, the `DT_RPATH` has
the highest priority, higher than `LD_LIBRARY_PATH`, so if this later one
is set in the environment, it should not interfere with the xPack binaries.

Please note that previous versions, up to mid-2020, used `DT_RUNPATH`, which
has a priority lower than `LD_LIBRARY_PATH`, and does not tolerate setting
it in the environment.

### `@executable_path`

Similarly, on macOS, the binaries are adjusted with `otool` to use a
relative path.

## Documentation

The original documentation is available in the `share/doc` folder.

## Build

The binaries for all supported platforms
(Windows, macOS and GNU/Linux) were built using the
[xPack Build Box (XBB)](https://xpack.github.io/xbb/), a set
of build environments based on slightly older distributions, that should be
compatible with most recent systems.

The scripts used to build this distribution are in:

- `distro-info/scripts`

For the prerequisites and more details on the build procedure, please see the
[README-MAINTAINER](https://github.com/xpack-dev-tools/ninja-build-xpack/blob/xpack/README-MAINTAINER.md) page.

## CI tests

Before publishing, a set of simple tests were performed on an exhaustive
set of platforms. The results are available from:

- [GitHub Actions](https://github.com/xpack-dev-tools/ninja-build-xpack/actions/)
- [Travis CI](https://app.travis-ci.com/github/xpack-dev-tools/ninja-build-xpack/builds/)

## Tests

TBD

## Checksums

The SHA-256 hashes for the files are:

```txt
ff591f7b164951a99fe7fd25cecda89c8b8c5467293e83568111b41ab2468551
xpack-ninja-build-1.10.2-4-darwin-x64.tar.gz

10f10f4318f25733ae36ba4e8862d9b41207201c1190b8cbacca62fa14539f49
xpack-ninja-build-1.10.2-4-linux-arm.tar.gz

ac654157c363286dd4c410bdb20fe391e3f7f4be7a9ca9ad4bea9f6aba461497
xpack-ninja-build-1.10.2-4-linux-arm64.tar.gz

c34f6b38de394e434d359ce6e1b02a1dcbf38225ce77f4ebf181588910c65358
xpack-ninja-build-1.10.2-4-linux-ia32.tar.gz

fbe473e04b2d27d91aa8297824b3a3f209ea6a83062fb6ef9e85ae23170aa5d6
xpack-ninja-build-1.10.2-4-linux-x64.tar.gz

5d745ce53dcc7bae1a6379055827a25505b1d5fb6f7e796a5eb7c215a7c89545
xpack-ninja-build-1.10.2-4-win32-ia32.zip

5d454007c161019a64af405ae08a7aa7e3556548c1f80ad6ceff0871907e3bce
xpack-ninja-build-1.10.2-4-win32-x64.zip

```

## Deprecation notices

### 32-bit support

Support for 32-bit x86 GNU/Linux and x86 Windows will most probably
be dropped in 2022. Support for 32-bit Arm GNU/Linux will be preserved
for a while, due to the large user base of 32-bit Raspberry Pi systems.

### GNU/Linux minimum requirements

Support for RedHat 7 will most probably be dropped in 2022, and the
minimum requirement will be raised to GLIBC 2.27, available starting
with Ubuntu 18 and RedHat 8.

## Download analytics

- GitHub [xpack-dev-tools/ninja-build-xpack](https://github.com/xpack-dev-tools/ninja-build-xpack/)
  - this release [![Github All Releases](https://img.shields.io/github/downloads/xpack-dev-tools/ninja-build-xpack/v{{ page.version }}/total.svg)](https://github.com/xpack-dev-tools/ninja-build-xpack/releases/v{{ page.version }}/)
  - all xPack releases [![Github All Releases](https://img.shields.io/github/downloads/xpack-dev-tools/ninja-build-xpack/total.svg)](https://github.com/xpack-dev-tools/ninja-build-xpack/releases/)
  - [individual file counters](https://somsubhra.github.io/github-release-stats/?username=xpack-dev-tools&repository=ninja-build-xpack) (grouped per release)
- npmjs.com [@xpack-dev-tools/ninja-build](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build)
  - latest releases [![npm](https://img.shields.io/npm/dw/@xpack-dev-tools/ninja-build.svg)](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build/)
  - all @xpack-dev-tools releases [![npm](https://img.shields.io/npm/dt/@xpack-dev-tools/ninja-build.svg)](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build/)

Credit to [Shields IO](https://shields.io) for the badges and to
[Somsubhra/github-release-stats](https://github.com/Somsubhra/github-release-stats)
for the individual file counters.
