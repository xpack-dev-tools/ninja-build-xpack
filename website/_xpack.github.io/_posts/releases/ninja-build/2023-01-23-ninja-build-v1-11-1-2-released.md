---

title:  xPack Ninja Build v1.11.1-2 released

summary: "Version **1.11.1-2** is a maintenance release, built with the latest build scripts."

ninja_version: 1.11.1
ninja_date: 30 Aug 2022
version: "1.11.1-2"
npm_subversion: 1

download_url: https://github.com/xpack-dev-tools/ninja-build-xpack/releases/tag/v1.11.1-2/

date: 2023-01-24 00:51:02 +0200

redirect_to: https://xpack-dev-tools.github.io/ninja-build-xpack/blog/2023/01/23/ninja-build-v1-11-1-2-released/

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

To remove the links created by xpm in the current project:

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
cbf57ea055028966107fa377b9e4325e4508308fcc47a238f4d678eb65c094ae
xpack-ninja-build-1.11.1-2-darwin-arm64.tar.gz

915eeff2cb8d106804435bca654cc81b35c935f8cd00be3b84e60d42aa5e8555
xpack-ninja-build-1.11.1-2-darwin-x64.tar.gz

28f68d64fdcf5fbb2e816dc4ae049c689ebbac6ddb5156bf7c4cf6b36c1d0efd
xpack-ninja-build-1.11.1-2-linux-arm.tar.gz

44e0263a886a75baf4fb56e348326dfb62ae5325c38a2ba02977982ecb1818a8
xpack-ninja-build-1.11.1-2-linux-arm64.tar.gz

cfd4c4b815183ef513151b05aa576974fc169164d4a706ca1f1b7c350b66107b
xpack-ninja-build-1.11.1-2-linux-x64.tar.gz

da68e7157bda76cb79c9b86ae00fd1856a24f971fdeab7138ab06ab6882c9d13
xpack-ninja-build-1.11.1-2-win32-x64.zip

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
