
[![GitHub package.json version](https://img.shields.io/github/package-json/v/xpack-dev-tools/ninja-build-xpack)](https://github.com/xpack-dev-tools/ninja-build-xpack/blob/xpack/package.json)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/xpack-dev-tools/ninja-build-xpack)](https://github.com/xpack-dev-tools/ninja-build-xpack/releases/)
[![npm (scoped)](https://img.shields.io/npm/v/@xpack-dev-tools/ninja-build.svg?color=blue)](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build/)
[![license](https://img.shields.io/github/license/xpack-dev-tools/ninja-build-xpack)](https://github.com/xpack-dev-tools/ninja-build-xpack/blob/xpack/LICENSE)

# The xPack Ninja Build

A standalone cross-platform (Windows/macOS/Linux) **Ninja Build**
binary distribution, intended for reproducible builds.

In addition to the the binary archives and the package meta data,
this project also includes the build scripts.

## Overview

This open source project is hosted on GitHub as
[`xpack-dev-tools/ninja-build-xpack`](https://github.com/xpack-dev-tools/ninja-build-xpack)
and provides the platform specific binaries for the
[xPack Ninja Build](https://xpack.github.io/ninja-build/).

This distribution follows the official
[Ninja](https://ninja-build.org) build system.

The binaries can be installed automatically as **binary xPacks** or manually as
**portable archives**.

## Release schedule

This distribution is generally one minor release behind the upstream releases.
In practical terms, when the minor release number changes, it awaits a few
more weeks to get the latest patch release.

## User info

This section is intended as a shortcut for those who plan
to use the Ninja Build binaries. For full details please read the
[xPack Ninja Build](https://xpack.github.io/ninja-build/) pages.

### Easy install

The easiest way to install Ninja Build is using the **binary xPack**, available as
[`@xpack-dev-tools/ninja-build`](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build)
from the [`npmjs.com`](https://www.npmjs.com) registry.

#### Prerequisites

A recent [xpm](https://xpack.github.io/xpm/),
which is a portable [Node.js](https://nodejs.org/) command line application.

It is recommended to update to the latest version with:

```sh
npm install --location=global xpm@latest
```

For details please follow the instructions in the
[xPack install](https://xpack.github.io/install/) page.

#### Install

With the `xpm` tool available, installing
the latest version of the package and adding it as
a development dependency for a project is quite easy:

```sh
cd my-project
xpm init # Only at first use.

xpm install @xpack-dev-tools/ninja-build@latest --verbose

ls -l xpacks/.bin
```

This command will:

- install the latest available version,
into the central xPacks store, if not already there
- add symbolic links to the central store
(or `.cmd` forwarders on Windows) into
the local `xpacks/.bin` folder.

The central xPacks store is a platform dependent
folder; check the output of the `xpm` command for the actual
folder used on your platform).
This location is configurable via the environment variable
`XPACKS_STORE_FOLDER`; for more details please check the
[xpm folders](https://xpack.github.io/xpm/folders/) page.

It is also possible to install Ninja Build globally, in the user home folder:

```sh
xpm install --global @xpack-dev-tools/ninja-build@latest --verbose
```

After install, the package should create a structure like this (macOS files;
only the first two depth levels are shown):

```console
$ tree -L 2 /Users/ilg/Library/xPacks/\@xpack-dev-tools/ninja-build/1.11.1-2.1/.content/
/Users/ilg/Library/xPacks/\@xpack-dev-tools/ninja-build/1.11.1-2.1/.content/
├── README.md
├── bin
│   └── ninja
└── distro-info
    ├── CHANGELOG.md
    ├── licenses
    ├── patches
    └── scripts

5 directories, 3 files
```

No other files are installed in any system folders or other locations.

#### Uninstall

The binaries are distributed as portable archives; thus they do not need
to run a setup and do not require an uninstall; simply removing the
folder is enough.

To remove the links created by xpm in the current project:

```sh
cd my-project

xpm uninstall @xpack-dev-tools/ninja-build
```

To completely remove the package from the global store:

```sh
xpm uninstall --global @xpack-dev-tools/ninja-build
```

### Manual install

For all platforms, the **xPack Ninja Build**
binaries are released as portable
archives that can be installed in any location.

The archives can be downloaded from the
GitHub [Releases](https://github.com/xpack-dev-tools/ninja-build-xpack/releases/)
page.

For more details please read the
[Install](https://xpack.github.io/ninja-build/install/) page.

### Versioning

The version strings used by the Ninja project are three number strings
like `1.11.1`; to this string the xPack distribution adds a four number,
but since semver allows only three numbers, all additional ones can
be added only as pre-release strings, separated by a dash,
like `1.11.1-2`. When published as a npm package, the version gets
a fifth number, like `1.11.1-2.1`.

Since adherence of third party packages to semver is not guaranteed,
it is recommended to use semver expressions like `^1.11.1` and `~1.11.1`
with caution, and prefer exact matches, like `1.11.1-2.1`.

## Maintainer info

For maintainer info, please see the
[README-MAINTAINER](https://github.com/xpack-dev-tools/ninja-build-xpack/blob/xpack/README-MAINTAINER.md)

## Support

The quick advice for getting support is to use the GitHub
[Discussions](https://github.com/xpack-dev-tools/ninja-build-xpack/discussions/).

For more details please read the
[Support](https://xpack.github.io/ninja-build/support/) page.

## License

The original content is released under the
[MIT License](https://opensource.org/licenses/MIT), with all rights
reserved to [Liviu Ionescu](https://github.com/ilg-ul/).

The binary distributions include several open-source components; the
corresponding licenses are available in the installed
`distro-info/licenses` folder.

## Download analytics

- GitHub [`xpack-dev-tools/ninja-build-xpack`](https://github.com/xpack-dev-tools/ninja-build-xpack/) repo
  - latest xPack release
[![Github All Releases](https://img.shields.io/github/downloads/xpack-dev-tools/ninja-build-xpack/latest/total.svg)](https://github.com/xpack-dev-tools/ninja-build-xpack/releases/)
  - all xPack releases [![Github All Releases](https://img.shields.io/github/downloads/xpack-dev-tools/ninja-build-xpack/total.svg)](https://github.com/xpack-dev-tools/ninja-build-xpack/releases/)
  - [individual file counters](https://somsubhra.github.io/github-release-stats/?username=xpack-dev-tools&repository=ninja-build-xpack) (grouped per release)
- npmjs.com [`@xpack-dev-tools/ninja-build`](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build/) xPack
  - latest release, per month
[![npm (scoped)](https://img.shields.io/npm/v/@xpack-dev-tools/ninja-build.svg)](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build/)
[![npm](https://img.shields.io/npm/dm/@xpack-dev-tools/ninja-build.svg)](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build/)
  - all releases [![npm](https://img.shields.io/npm/dt/@xpack-dev-tools/ninja-build.svg)](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build/)

Credit to [Shields IO](https://shields.io) for the badges and to
[Somsubhra/github-release-stats](https://github.com/Somsubhra/github-release-stats)
for the individual file counters.
