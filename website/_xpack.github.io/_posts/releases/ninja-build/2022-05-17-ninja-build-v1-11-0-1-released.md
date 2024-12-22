---

title:  xPack Ninja Build v1.11.0-1 released
sidebar: ninja-build

summary: "Version **1.11.0-1** is a new release; it follows the upstream release."

ninja_version: 0.11.1
ninja_date: May 15, 2022
version: 1.11.0-1
npm_subversion: 1

download_url: https://github.com/xpack-dev-tools/ninja-build-xpack/releases/tag/v1.11.0-1/

date: 2022-05-17 10:07:07 +0300

redirect_to: https://xpack-dev-tools.github.io/ninja-build-xpack/blog/2022/05/17/ninja-build-v1-11-0-1-released/

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

There are separate binaries for **Windows** (x64),
**macOS** (x64, arm64)
and **GNU/Linux** (x64, arm64 and arm).

{% include note.html content="The main targets for the GNU/Linux Arm
binaries are the **Raspberry Pi** class devices (armv7l and aarch64;
armv6 is not supported)." %}

## Download

The binary files are available from [GitHub Releases]({{ page.download_url }}).

## Prerequisites

- x64 GNU/Linux: any system with **GLIBC 2.27** or higher
  (like Ubuntu 18 or later, Debian 10 or later, RedHat 8 or later,
  Fedora 29 or later, etc)
- arm64/arm GNU/Linux: any system with **GLIBC 2.27** or higher
  (like Raspberry Pi OS, Ubuntu 18 or later, Debian 10 or later, RedHat 8 or later,
  Fedora 29 or later, etc)
- x64 Windows: Windows 7 with the Universal C Runtime
  ([UCRT](https://support.microsoft.com/en-us/topic/update-for-universal-c-runtime-in-windows-c0514201-7fe6-95a3-b0a5-287930f3560c)),
  Windows 8, Windows 10
- x64 macOS: 10.13 or later
- arm64 macOS: 11.6 or later

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

- Ninja Build version {{ page.ninja_version }}
from {{ page.ninja_date }}.

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

### `@rpath` and `@loader_path`

Similarly, on macOS, the binaries are adjusted with `install_name_tool` to use a
relative path.

## Documentation

The original documentation is available
[online](https://ninja-build.org/manual.html).

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
2136e497c0fb108d98ce19d60a7771ee12ed7d64738a936ad5a3bd93a8f252f7
xpack-ninja-build-1.11.0-1-darwin-arm64.tar.gz

9fc6b2856241c91783babf2d152f0692d59a5d889ea932e2712f7571911872f4
xpack-ninja-build-1.11.0-1-darwin-x64.tar.gz

bf41c8e1fea0f2ca35a7d0f4b25906b0d39eddd3e56d1f951fa6e63d05c49bd6
xpack-ninja-build-1.11.0-1-linux-arm.tar.gz

7f403b2bcb590f53fe16c16549102ff2e91f075d9e3aa5b8bbefcaa813392cd8
xpack-ninja-build-1.11.0-1-linux-arm64.tar.gz

1f80673a9d1467947f2b45075e93431405ad35909cc6ddbfcd0aba07f1b10b4b
xpack-ninja-build-1.11.0-1-linux-x64.tar.gz

99f2047df30825e687d711c5dc5c9fe0affdb2d3d076a5f8936263f5060cffd0
xpack-ninja-build-1.11.0-1-win32-x64.zip

```

## Deprecation notices

### 32-bit support

Support for 32-bit x86 GNU/Linux and x86 Windows was
dropped in 2022. Support for 32-bit Arm GNU/Linux (armv7l) will be preserved
for a while, due to the large user base of 32-bit Raspberry Pi systems.

### GNU/Linux minimum requirements

Support for RedHat 7 was dropped in 2022 and the
minimum requirement was raised to GLIBC 2.27, available starting
with Ubuntu 18, Debian 10 and RedHat 8.

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
