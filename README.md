
[![npm (scoped)](https://img.shields.io/npm/v/@xpack-dev-tools/ninja-build.svg)](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build/)
[![npm](https://img.shields.io/npm/dt/@xpack-dev-tools/ninja-build.svg)](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build/)

# The xPack Ninja Build

This open source project is hosted on GitHub as
[`xpack-dev-tools/ninja-build-xpack`](https://github.com/xpack-dev-tools/ninja-build-xpack)
and provides the platform specific binaries for the
[xPack Ninja Build](https://xpack.github.io/ninja-build/).

This distribution follows the official [Ninja](http://ninja-build.org) build system.

The binaries can be installed automatically as **binary xPacks** or manually as
**portable archives**.

In addition to the package meta data, this project also includes
the build scripts.

## User info

This section is intended as a shortcut for those who plan
to use the Ninja Build binaries. For full details please read the
[xPack Ninja Build](https://xpack.github.io/ninja-build/) pages.

### Easy install

The easiest way to install Ninja Build is using the **binary xPack**, available as
[`@xpack-dev-tools/ninja-build`](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build)
from the [`npmjs.com`](https://www.npmjs.com) registry.

#### Prerequisites

The only requirement is a recent
`xpm`, which is a portable
[Node.js](https://nodejs.org) command line application. To install it,
follow the instructions from the
[xpm](https://xpack.github.io/xpm/install/) page.

#### Install

With the `xpm` tool available, installing
the latest version of the package is quite easy:

```console
xpm install --global @xpack-dev-tools/ninja-build@latest
```

This command will always install the latest available version,
into the central xPacks repository, which is a platform dependent folder
(check the output of the `xpm` command for the actual folder used on
your platform).

This location is configurable using the environment variable
`XPACKS_REPO_FOLDER`; for more details please check the
[xpm folders](https://xpack.github.io/xpm/folders/) page.

xPacks aware tools automatically
identify binaries installed with
`xpm` and provide a convenient method to manage paths.

#### Uninstall

To remove the installed xPack, the command is similar:

```console
xpm uninstall --global @xpack-dev-tools/ninja-build
```

(Note: not yet implemented. As a temporary workaround, simply remove the
`xPacks/@xpack-dev-tools/ninja-build` folder, or one of the the versioned
subfolders.)

### Manual install

For all platforms, the **xPack Ninja Build** binaries are released as portable
archives that can be installed in any location.

The archives can be downloaded from the
GitHub [releases](https://github.com/xpack-dev-tools/ninja-build-xpack/releases/)
page.

For more details please read the
[Install](https://xpack.github.io/ninja-build/install/) page.

### Version information

The version strings used by the Ninja project are three number string
like `1.10.0`; to this string the xPack distribution adds a four number,
but since semver allows only three numbers, all additional ones can
be added only as pre-release strings, separated by a dash,
like `1.10.0-1`. When published as a npm package, the version gets
a fifth number, like `1.10.0-1.1`.

Since adherance of third party packages to semver is not guaranteed,
it is recommended to use semver expressions like `^1.10.0` and `~1.10.0`
with caution, and prefer exact matches, like `1.10.0-1.1`.

## Maintainer info

- [How to build](https://github.com/xpack-dev-tools/ninja-build-xpack/blob/xpack/README-BUILD.md)
- [How to publish](https://github.com/xpack-dev-tools/ninja-build-xpack/blob/xpack/README-RELEASE.md)

## Support

The quick answer is to use the
[xPack forums](https://www.tapatalk.com/groups/xpack/);
please select the correct forum.

For more details please read the
[Support](https://xpack.github.io/ninja-build/support/) page.

## License

The original content is released under the
[MIT License](https://opensource.org/licenses/MIT), with all rights
reserved to [Liviu Ionescu](https://github.com/ilg-ul).

The binary distributions include several open-source components; the
corresponding licenses are available in the installed
`distro-info/licenses` folder.

## Download analytics

- GitHub [`xpack-dev-tools/ninja-build-xpack`](https://github.com/xpack-dev-tools/ninja-build-xpack/) repo
  - latest xPack release
[![Github All Releases](https://img.shields.io/github/downloads/xpack-dev-tools/ninja-build-xpack/latest/total.svg)](https://github.com/xpack-dev-tools/ninja-build-xpack/releases/)
  - all xPack releases [![Github All Releases](https://img.shields.io/github/downloads/xpack-dev-tools/ninja-build-xpack/total.svg)](https://github.com/xpack-dev-tools/ninja-build-xpack/releases/)
  - [individual file counters](https://www.somsubhra.com/github-release-stats/?username=xpack-dev-tools&repository=ninja-build-xpack) (grouped per release)
- npmjs.com [`@xpack-dev-tools/ninja-build`](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build/) xPack
  - latest release, per month
[![npm (scoped)](https://img.shields.io/npm/v/@xpack-dev-tools/ninja-build.svg)](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build/)
[![npm](https://img.shields.io/npm/dm/@xpack-dev-tools/ninja-build.svg)](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build/)
  - all releases [![npm](https://img.shields.io/npm/dt/@xpack-dev-tools/ninja-build.svg)](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build/)

Credit to [Shields IO](https://shields.io) for the badges and to
[Somsubhra/github-release-stats](https://github.com/Somsubhra/github-release-stats)
for the individual file counters.
