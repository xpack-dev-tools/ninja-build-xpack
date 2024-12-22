---

title: How to install the xPack Ninja Build binaries
permalink: /dev-tools/ninja-build/install/

summary: "The recommended method is via xpm."

version: "1.11.0"
xpack-subversion: "1"

comments: true
toc: false

date: 2020-09-27 11:09:00 +0300

redirect_to: https://xpack-dev-tools.github.io/ninja-build-xpack/docs/install/

---

## Overview

The **xPack Ninja Build** can be installed automatically, via `xpm` (the
recommended method), or manually, by downloading and unpacking one of the
portable archives.

{% capture easy_install %}

## Easy install

The easiest way to install Ninja is by using the **binary xPack**, available as
[`@xpack-dev-tools/ninja-build`](https://www.npmjs.com/package/@xpack-dev-tools/ninja-build)
from the [`npmjs.com`](https://www.npmjs.com) registry.

### Prerequisites

The only requirement is a recent
xpm, which is a portable
[Node.js](https://nodejs.org) command line application. To install it,
follow the instructions from the
[xpm install]({{ site.baseurl }}/xpm/install/) page.

### Install

With xpm available, installing
the latest version of the package is quite easy:

```sh
cd my-project
xpm init # Only at first use.

xpm install @xpack-dev-tools/ninja-build@latest --verbose
```

This command will always install the latest available version,
in the global xPacks store, which is a platform dependent folder
(check the output of the `xpm` command for the actual folder used on
your platform).

{% capture include_1 %}
The install location can be configured using the
`XPACKS_STORE_FOLDER` environment variable; for more details please check the
[xpm folders]({{ site.baseurl }}/xpm/folders/) page.
{% endcapture %}

{% include tip.html content=include_1 %}

{% include tip.html content="The archive content is unpacked into a folder
named `.content`. On some platforms
this might be hidden for normal browsing, and require
separate options (like `ls -A`) or, in file browsers, to enable
settings like **Show Hidden Files**." %}

### Uninstall

To remove the links from the current project:

```sh
cd my-project

xpm uninstall @xpack-dev-tools/ninja-build
```

To completely remove the package from the central xPacks store:

```sh
xpm uninstall --global @xpack-dev-tools/ninja-build --verbose
```

{% endcapture %}

{% capture manual_install %}

## Manual install

For all platforms, the **xPack Ninja Build** binaries are released as portable
archives that can be installed in any location.

The archives can be downloaded from the
GitHub [releases](https://github.com/xpack-dev-tools/ninja-build-xpack/releases/)
page.

{% endcapture %}

{% capture windows %}

{{ easy_install }}

### Test

To check if the xpm installed Ninja starts, use something like:

```doscon
C:\>%USERPROFILE%\AppData\Roaming\xPacks\@xpack-dev-tools\ninja-build\{{ page.version }}-{{ page.xpack-subversion }}.1\.content\bin\ninja.exe --version
{{ page.version }}
```

{{ manual_install }}

### Download

The Windows versions of **xPack Ninja Build**
are packed as ZIP files.
Download the latest version named like:

- `xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}-win32-x64.zip`

{% include note.html content="In case you wonder where the suffix comes
from, it is exactly the Node.js `process.platform` and `process.arch`.
The `win32` part is confusing, but we have to live with it." %}

### Unpack

To manually install the xPack Ninja Build,
unpack the archive and copy it into the
`%USERPROFILE%\AppData\Roaming\xPacks\ninja-build`
(for example `C:\Users\ilg\AppData\Roaming\xPacks\ninja-build`) folder;
according to Microsoft, `AppData\Roaming` is the recommended location for
installing user specific packages.

{% include note.html content="For manual installs, the recommended
install location is slightly different from the xpm install folders,
which use the scope (like `@xpack-dev-tools`) to group different tools,
and `.content` to store the unpacked archive." %}

### Test

To check if the manually installed Ninja starts, use something like:

```doscon
C:\>%USERPROFILE%\AppData\Roaming\xPacks\ninja-build\xpack-ninja-{{ page.version }}-{{ page.xpack-subversion }}\bin\ninja.exe --version
{{ page.version }}
```

{% endcapture %}

{% capture macos %}

{{ easy_install }}

### Test

To check if the xpm installed Ninja starts, use something like:

```console
$ ~/.local/xPacks/@xpack-dev-tools/ninja-build/{{ page.version }}-{{ page.xpack-subversion }}.1/.content/bin/ninja --version
{{ page.version }}
```

{{ manual_install }}

### Download

The macOS versions of **xPack Ninja Build**
are packed as `.tar.gz` archives.
Download the latest version named like:

- `xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}-darwin-x64.tar.gz`
- `xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}-darwin-arm64.tar.gz`

### Unpack

To manually install the xPack Ninja Build,
unpack the archive and move it to
`~/.local/xPacks/ninja-build/xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}`:

```sh
mkdir -p ~/.local/xPacks/ninja-build
cd ~/.local/xPacks/ninja-build

tar xvf ~/Downloads/xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}-darwin-x64.tar.gz
chmod -R -w xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}
```

{% include note.html content="For manual installs, the recommended
install location is different from the xpm install folders." %}

The result is a structure like:

```console
$ tree -L 2 /Users/ilg/.local/xPacks/ninja-build/xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}
/Users/ilg/.local/xPacks/ninja-build/xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}/
├── README.md
├── bin
│   └── ninja
└── distro-info
    ├── CHANGELOG.md
    ├── licenses
    ├── patches
    └── scripts

5 directories, 3 files
```

### Test

To check if the manually installed Ninja starts, use something like:

```console
$ ~/.local/xPacks/ninja-build/{{ page.version }}-{{ page.xpack-subversion }}/bin/ninja --version
{{ page.version }}
```

{% endcapture %}

{% capture linux %}

{{ easy_install }}

### Test

To check if the xpm installed Ninja starts, use something like:

```console
$ ~/.local/xPacks/@xpack-dev-tools/ninja-build/{{ page.version }}-{{ page.xpack-subversion }}.1/.content/bin/ninja --version
{{ page.version }}
```

{{ manual_install }}

### Download

The GNU/Linux versions of **xPack Ninja Build**
are packed as `.tar.gz` archives.
Download the latest version named like:

- `xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}-linux-x64.tar.gz`
- `xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}-linux-arm.tar.gz`
- `xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}-linux-arm64.tar.gz`

As the name implies, these are GNU/Linux `tar.gz` archives; they were build on
Ubuntu, but can be executed on most recent GNU/Linux distributions.

### Unpack

To manually install the xPack Ninja Build,
unpack the archive and move it to
`~/.local/xPacks/ninja-build/xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}`:

```sh
mkdir -p ~/.local/xPacks/ninja-build
cd ~/.local/xPacks/ninja-build

tar xvf ~/Downloads/xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}-linux-x64.tar.gz
chmod -R -w xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}
```

{% include note.html content="For manual installs, the recommended
install location is slightly different from the xpm install folders,
which use the scope (like `@xpack-dev-tools`) to group different tools,
and `.content` to store the unpacked archive." %}

```console
$ tree -L 2 '/home/ilg/.local/xPacks/ninja-build/xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}'
/home/ilg/.local/xPacks/ninja-build/xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}/
├── bin
│   └── ninja
├── distro-info
│   ├── CHANGELOG.md
│   ├── licenses
│   ├── patches
│   └── scripts
└── README.md

5 directories, 3 files
```

### Test

To check if the manually installed Ninja starts, use something like:

```console
$ ~/.local/xPacks/ninja-build/xpack-ninja-build-{{ page.version }}-{{ page.xpack-subversion }}/bin/ninja --version
{{ page.version }}
```

{% endcapture %}

{% include platform-tabs.html %}

## Testing

TODO
