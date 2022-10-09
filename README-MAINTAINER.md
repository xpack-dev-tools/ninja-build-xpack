[![license](https://img.shields.io/github/license/xpack-dev-tools/ninja-build-xpack)](https://github.com/xpack-dev-tools/ninja-build-xpack/blob/xpack/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/xpack-dev-tools/ninja-build-xpack.svg)](https://github.com/xpack-dev-tools/ninja-build-xpack/issues/)
[![GitHub pulls](https://img.shields.io/github/issues-pr/xpack-dev-tools/ninja-build-xpack.svg)](https://github.com/xpack-dev-tools/ninja-build-xpack/pulls)

# Maintainer info

## Project repository

The project is hosted on GitHub:

- <https://github.com/xpack-dev-tools/ninja-build-xpack.git>

To clone the stable branch (`xpack`), run the following commands in a
terminal (on Windows use the _Git Bash_ console):

```sh
rm -rf ~/Work/ninja-build-xpack.git; \
git clone https://github.com/xpack-dev-tools/ninja-build-xpack.git \
  ~/Work/ninja-build-xpack.git; \
```

For development purposes, clone the `xpack-develop` branch:

```sh
rm -rf ~/Work/ninja-build-xpack.git; \
git clone \
  --branch xpack-develop \
  https://github.com/xpack-dev-tools/ninja-build-xpack.git \
  ~/Work/ninja-build-xpack.git; \
```

## Prerequisites

A recent [xpm](https://xpack.github.io/xpm/), which is a portable
[Node.js](https://nodejs.org/) command line application.

## Release schedule

The xPack Ninja Build release schedule generally follows the original GitHub
[releases](https://github.com/ninja-build/ninja/releases/), but with a
few weeks filter, which means that releases that are overridden in
a few weeks may be skipped.

## How to make new releases

## Prepare the build

Before starting the build, perform some checks and tweaks.

### Download the build scripts

The build scripts are available in the `scripts` folder of the
[`xpack-dev-tools/ninja-build-xpack`](https://github.com/xpack-dev-tools/ninja-build-xpack)
Git repo.

To download them on a new machine, clone the `xpack-develop` branch,
as seen above.

### Check Git

In the `xpack-dev-tools/ninja-build-xpack` Git repo:

- switch to the `xpack-develop` branch
- pull new changes
- if needed, merge the `xpack` branch

No need to add a tag here, it'll be added when the release is created.

### Check the latest upstream release

Check the Ninja Build GitHub [Releases](https://github.com/ninja-build/ninja/releases/)
and compare the the xPack [Releases](https://github.com/xpack-dev-tools/ninja-build-xpack/releases/).

### Increase the version

Determine the version (like `1.11.1`) and update the `scripts/VERSION`
file; the format is `1.11.1-2`. The fourth number is the xPack release number
of this version. A fifth number will be added when publishing
the package on the `npm` server.

### Fix possible open issues

Check GitHub issues and pull requests:

- <https://github.com/xpack-dev-tools/ninja-build-xpack/issues/>

and fix them; assign them to a milestone (like `1.11.1-2`).

### Check `README.md`

Normally `README.md` should not need changes, but better check.
Information related to the new version should not be included here,
but in the version specific release page.

### Update versions in `README` files

- update version in `README-RELEASE.md`
- update version in `README.md`

### Update `CHANGELOG.md`

- open the `CHANGELOG.md` file
- check if all previous fixed issues are in
- add a new entry like _* v1.11.1-2 prepared_
- commit with a message like _prepare v1.11.1-2_

### Merge upstream repo

To keep the development repository in sync with the original Ninja
repository, in the `xpack-dev-tools/ninja` Git fork repo:

- fetch `upstream`
- checkout `release`
- merge from `upstream/release`
- checkout `xpack-develop`
- merge `release`
- checkout `xpack`
- merge `xpack-develop`
- tag it with `v1.11.1-2-xpack`; important, this tag will be used by the build
- push `release`, `xpack-develop`, `xpack` to `origin`

### Update the version specific code

- open the `scripts/versioning.sh` file
- add a new `if` with the new version before the existing code

## Build

The builds currently run on 5 dedicated machines (Intel GNU/Linux,
Arm 32 GNU/Linux, Arm 64 GNU/Linux, Intel macOS and Arm macOS.

### Development run the build scripts

Before the real build, run a test build on all platforms.

#### Intel macOS

For Intel macOS, first run the build on the development machine (`wksi`):

```sh
# Update the build scripts.
git pull -C ~/Work/ninja-build-xpack.git

xpm install -C ~/Work/ninja-build-xpack.git

# For backup overhead reasons, on the development machine
# the builds happen on a separate Work folder.
rm -rf ~/Work/ninja-build-[0-9]*-*

xpm install --config darwin-x64 -C ~/Work/ninja-build-xpack.git
caffeinate xpm run build-develop --config darwin-x64 -C ~/Work/ninja-build-xpack.git
```

When functional, push the `xpack-develop` branch to GitHub.

Run the build on the production machine (`xbbmi`):

```sh
caffeinate ssh xbbmi
```

```sh
# Update the build scripts (or clone them the first time).
git pull -C ~/Work/ninja-build-xpack.git

xpm install -C ~/Work/ninja-build-xpack.git

xpm run deep-clean --config darwin-x64 -C ~/Work/ninja-build-xpack.git

xpm install --config darwin-x64 -C ~/Work/ninja-build-xpack.git
caffeinate xpm run build-develop --config darwin-x64 -C ~/Work/ninja-build-xpack.git
```

Several minutes later, the output of the build script is a compressed
archive and its SHA signature, created in the `deploy` folder:

```console
$ ls -l ~/Work/ninja-build-xpack.git/build/darwin-x64/deploy
total 1080
-rw-r--r--  1 ilg  staff  547972 May 17 09:50 xpack-ninja-build-1.11.1-2-darwin-x64.tar.gz
-rw-r--r--  1 ilg  staff     111 May 17 09:50 xpack-ninja-build-1.11.1-2-darwin-x64.tar.gz.sha
```

#### Apple Silicon macOS

Run the build on the production machine (`xbbma`):

```sh
caffeinate ssh xbbma
```

```sh
# Update the build scripts (or clone them the first time).
git pull -C ~/Work/ninja-build-xpack.git

xpm install -C ~/Work/ninja-build-xpack.git

xpm run deep-clean --config darwin-arm64 -C ~/Work/ninja-build-xpack.git

xpm install --config darwin-arm64 -C ~/Work/ninja-build-xpack.git
caffeinate xpm run build-develop --config darwin-arm64 -C ~/Work/ninja-build-xpack.git
```

Several minutes later, the output of the build script is a compressed
archive and its SHA signature, created in the `deploy` folder:

```console
$ ls -l ~/Work/ninja-build-xpack.git/build/darwin-arm64/deploy
total 1056
-rw-r--r--  1 ilg  staff  533014 May 17 09:49 xpack-ninja-build-1.11.1-2-darwin-arm64.tar.gz
-rw-r--r--  1 ilg  staff     113 May 17 09:49 xpack-ninja-build-1.11.1-2-darwin-arm64.tar.gz.sha
```

#### Intel GNU/Linux

Run the build on the production machine (`xbbli`):

```sh
caffeinate ssh xbbli
```

Build the GNU/Linux binaries:

```sh
# Update the build scripts (or clone them the first time).
git pull -C ~/Work/ninja-build-xpack.git

xpm install -C ~/Work/ninja-build-xpack.git

xpm run deep-clean --config linux-x64 -C ~/Work/ninja-build-xpack.git

xpm install --config linux-x64 -C ~/Work/ninja-build-xpack.git
xpm run build-develop --config linux-x64 -C ~/Work/ninja-build-xpack.git
```

Several minutes later, the output of the build script is a compressed
archive and its SHA signature, created in the `deploy` folder:

```console
$ ls -l ~/Work/ninja-build-xpack.git/build/linux-x64/deploy
total 1480
-rw-rw-rw- 1 ilg ilg 551495 May 17 09:49 xpack-ninja-build-1.11.1-2-linux-x64.tar.gz
-rw-rw-rw- 1 ilg ilg    110 May 17 09:49 xpack-ninja-build-1.11.1-2-linux-x64.tar.gz.sha
```

Build the Windows binaries:

```sh
xpm run deep-clean --config win32-x64 -C ~/Work/ninja-build-xpack.git

xpm install --config win32-x64 -C ~/Work/ninja-build-xpack.git
xpm run build-develop --config win32-x64 -C ~/Work/ninja-build-xpack.git
```

Several minutes later, the output of the build script is a compressed
archive and its SHA signature, created in the `deploy` folder:

```console
$ ls -l ~/Work/ninja-build-xpack.git/build/win32-x64/deploy
total 1480
-rw-rw-rw- 1 ilg ilg 951474 May 17 09:50 xpack-ninja-build-1.11.1-2-win32-x64.zip
-rw-rw-rw- 1 ilg ilg    107 May 17 09:50 xpack-ninja-build-1.11.1-2-win32-x64.zip.sha
```

#### Arm GNU/Linux 64-bit

Run the build on the production machine (`xbbla64`):

```sh
caffeinate ssh xbbla64
```

```sh
# Update the build scripts (or clone if the first time)
git pull -C ~/Work/ninja-build-xpack.git

xpm install -C ~/Work/ninja-build-xpack.git

xpm run deep-clean --config linux-arm64 -C ~/Work/ninja-build-xpack.git

xpm install --config linux-arm64 -C ~/Work/ninja-build-xpack.git
xpm run build-develop --config linux-arm64 -C ~/Work/ninja-build-xpack.git
```

Several minutes later, the output of the build script is a compressed
archive and its SHA signature, created in the `deploy` folder:

```console
$ ls -l ~/Work/ninja-build-xpack.git/build/linux-arm64/deploy
total 532
-rw-rw-rw- 1 ilg ilg 538649 May 17 09:51 xpack-ninja-build-1.11.1-2-linux-arm64.tar.gz
-rw-rw-rw- 1 ilg ilg    112 May 17 09:51 xpack-ninja-build-1.11.1-2-linux-arm64.tar.gz.sha
```

#### Arm GNU/Linux 32-bit

Run the build on the production machine (`xbbla32`):

```sh
caffeinate ssh xbbla32
```

```sh
# Update the build scripts (or clone if the first time)
git pull -C ~/Work/ninja-build-xpack.git

xpm install -C ~/Work/ninja-build-xpack.git

xpm run deep-clean --config linux-arm -C ~/Work/ninja-build-xpack.git

xpm install --config linux-arm -C ~/Work/ninja-build-xpack.git
xpm run build-develop --config linux-arm -C ~/Work/ninja-build-xpack.git
```

Several minutes later, the output of the build script is a compressed
archive and its SHA signature, created in the `deploy` folder:

```console
$ ls -l ~/Work/ninja-build-xpack.git/build/linux-arm/deploy
total 500
-rw-rw-rw- 1 ilg ilg 506541 May 17 09:51 xpack-ninja-build-1.11.1-2-linux-arm.tar.gz
-rw-rw-rw- 1 ilg ilg    110 May 17 09:51 xpack-ninja-build-1.11.1-2-linux-arm.tar.gz.sha
```

### Files cache

The XBB build scripts use a local cache such that files are downloaded only
during the first run, later runs being able to use the cached files.

However, occasionally some servers may not be available, and the builds
may fail.

The workaround is to manually download the files from an alternate
location (like
<https://github.com/xpack-dev-tools/files-cache/tree/master/libs>),
place them in the XBB cache (`Work/cache`) and restart the build.

## Run the CI build

The automation is provided by GitHub Actions and three self-hosted runners.

Run the `generate-workflows` to re-generate the
GitHub workflow files; commit and push if necessary.

- on the macOS machine (`xbbmi`) open ssh sessions to the build
machines (`xbbma`, `xbbli`, `xbbla64` and `xbbla32`):

```sh
caffeinate ssh xbbma
caffeinate ssh xbbli
caffeinate ssh xbbla64
caffeinate ssh xbbla32
```

Start the runner on all machines:

```sh
screen -S ga

~/actions-runners/xpack-dev-tools/run.sh &

# Ctrl-a Ctrl-d
```

Check that both the project Git and the submodule are pushed to GitHub.

To trigger the GitHub Actions build, use the xPack action:

- `trigger-workflow-build-xbbli`
- `trigger-workflow-build-xbbla64`
- `trigger-workflow-build-xbbla32`
- `trigger-workflow-build-xbbmi`
- `trigger-workflow-build-xbbma`

This is equivalent to:

```sh
bash ~/Work/ninja-build-xpack.git/scripts/helper/trigger-workflow-build.sh --machine xbbli
bash ~/Work/ninja-build-xpack.git/scripts/helper/trigger-workflow-build.sh --machine xbbla64
bash ~/Work/ninja-build-xpack.git/scripts/helper/trigger-workflow-build.sh --machine xbbla32
bash ~/Work/ninja-build-xpack.git/scripts/helper/trigger-workflow-build.sh --machine xbbmi
bash ~/Work/ninja-build-xpack.git/scripts/helper/trigger-workflow-build.sh --machine xbbma
```

These scripts require the `GITHUB_API_DISPATCH_TOKEN` variable to be present
in the environment, and the organization `PUBLISH_TOKEN` to be visible in the
Settings → Action →
[Secrets](https://github.com/xpack-dev-tools/ninja-build-xpack/settings/secrets/actions)
page.

This command uses the `xpack-develop` branch of this repo.

The builds take 2-3 minutes to complete.

The workflow result and logs are available from the
[Actions](https://github.com/xpack-dev-tools/ninja-build-xpack/actions/) page.

The resulting binaries are available for testing from
[pre-releases/test](https://github.com/xpack-dev-tools/pre-releases/releases/tag/test/).

## Testing

### CI tests

The automation is provided by GitHub Actions.

From the development machine open a ssh sessions to the Arm GNU/Linux
test machine `xbbla`:

```sh
caffeinate ssh xbbla
```

Start both runners (to allow the 32/64-bit tests to run in parallel):

```sh
~/actions-runners/xpack-dev-tools/1/run.sh &
~/actions-runners/xpack-dev-tools/2/run.sh &
```

To trigger the GitHub Actions tests, use the xPack actions:

- `trigger-workflow-test-prime`
- `trigger-workflow-test-docker-linux-intel`
- `trigger-workflow-test-docker-linux-arm`

These are equivalent to:

```sh
bash ~/Work/ninja-build-xpack.git/scripts/helper/tests/trigger-workflow-test-prime.sh
bash ~/Work/ninja-build-xpack.git/scripts/helper/tests/trigger-workflow-test-docker-linux-intel.sh
bash ~/Work/ninja-build-xpack.git/scripts/helper/tests/trigger-workflow-test-docker-linux-arm.sh
```

These scripts require the `GITHUB_API_DISPATCH_TOKEN` variable to be present
in the environment.

These actions use the `xpack-develop` branch of this repo and the
[pre-releases/test](https://github.com/xpack-dev-tools/pre-releases/releases/tag/test/)
binaries.

The tests results are available from the
[Actions](https://github.com/xpack-dev-tools/ninja-build-xpack/actions/) page.

Since GitHub Actions provides a single version of macOS, the
multi-version macOS tests run on Travis.

To trigger the Travis test, use the xPack action:

- `trigger-travis-macos`

This is equivalent to:

```sh
bash ~/Work/ninja-build-xpack.git/scripts/helper/tests/trigger-travis-macos.sh
```

This script requires the `TRAVIS_COM_TOKEN` variable to be present
in the environment.

The test results are available from
[Travis CI](https://app.travis-ci.com/github/xpack-dev-tools/ninja-build-xpack/builds/).

### Manual tests

Install the binaries on all platforms.

On GNU/Linux and macOS systems, use:

```sh
.../xpack-ninja-build-1.11.1-2/bin/ninja --version
1.11.1
```

On Windows use:

```dos
...\xpack-ninja-build-1.11.1-2\bin\ninja --version
1.11.1
```

## Create a new GitHub pre-release draft

- in `CHANGELOG.md`, add the release date and a message like _* v1.11.1-2 released_
- commit with _CHANGELOG update_
- check and possibly update the `templates/body-github-release-liquid.md`
- push the `xpack-develop` branch
- run the xPack action `trigger-workflow-publish-release`

The workflow result and logs are available from the
[Actions](https://github.com/xpack-dev-tools/ninja-build-xpack/actions/) page.

The result is a
[draft pre-release](https://github.com/xpack-dev-tools/ninja-build-xpack/releases/)
tagged like **v1.11.1-2** (mind the dash in the middle!) and
named like **xPack Ninja Build v1.11.1-2** (mind the dash),
with all binaries attached.

- edit the draft and attach it to the `xpack-develop` branch (important!)
- save the draft (do **not** publish yet!)

## Prepare a new blog post

- check and possibly update the `templates/body-jekyll-release-*-liquid.md`
- run the xPack action `generate-jekyll-post`; this will leave a file
on the Desktop.

In the `xpack/web-jekyll` GitHub repo:

- select the `develop` branch
- copy the new file to `_posts/releases/ninja-build`
- update version and date from last
[release](https://github.com/ninja-build/ninja/releases/).

If any, refer to closed
[issues](https://github.com/xpack-dev-tools/ninja-build-xpack/issues/).

## Update the preview Web

- commit the `develop` branch of `xpack/web-jekyll` GitHub repo;
  use a message like _xPack Ninja Build v1.11.1-2 released_
- push to GitHub
- wait for the GitHub Pages build to complete
- the preview web is <https://xpack.github.io/web-preview/news/>

## Create the pre-release

- go to the GitHub [Releases](https://github.com/xpack-dev-tools/ninja-build-xpack/releases/) page
- perform the final edits and check if everything is fine
- temporarily fill in the _Continue Reading »_ with the URL of the
  web-preview release
- **keep the pre-release button enabled**
- do not enable Discussions yet
- publish the release

Note: at this moment the system should send a notification to all clients
watching this project.

## Update the READMEs listings and examples

- check and possibly update the `ls -l` output
- check and possibly update the output of the `--version` runs
- check and possibly update the output of `tree -L 2` in the README file
- commit changes

## Check the list of links

- open the `package.json` file
- check if the links in the `bin` property cover the actual binaries
- if necessary, also check on Windows

## Update package.json binaries

- select the `xpack-develop` branch
- run the xPack action `update-package-binaries`
- open the `package.json` file
- check the `baseUrl:` it should match the file URLs (including the tag/version);
  no terminating `/` is required
- from the release, check the SHA & file names
- compare the SHA sums with those shown by `cat *.sha`
- check the executable names
- commit all changes, use a message like
  _package.json: update urls for 1.11.1-2.1 release_ (without _v_)

## Publish on the npmjs.com server

- select the `xpack-develop` branch
- check the latest commits `npm run git-log`
- update `CHANGELOG.md`, add a line like _* v1.11.1-2.1 published on npmjs.com_
- commit with a message like _CHANGELOG: publish npm v1.11.1-2.1_
- `npm pack` and check the content of the archive, which should list
  only the `package.json`, the `README.md`, `LICENSE` and `CHANGELOG.md`;
  possibly adjust `.npmignore`
- `npm version 1.11.1-2.1`; the first 4 numbers are the same as the
  GitHub release; the fifth number is the npm specific version
- the commits and the tag should have been pushed by the `postversion` script;
  if not, push them with `git push origin --tags`
- `npm publish --tag next` (use `npm publish --access public`
  when publishing for the first time; add the `next` tag)

After a few moments the version will be visible at:

- <https://www.npmjs.com/package/@xpack-dev-tools/ninja-build?activeTab=versions>

## Test if the binaries can be installed with xpm

Run the xPack action `trigger-workflow-test-xpm`, this
will install the package via `xpm install` on all supported platforms.

The tests results are available from the
[Actions](https://github.com/xpack-dev-tools/ninja-build-xpack/actions/) page.

## Update the repo

- merge `xpack-develop` into `xpack`
- push to GitHub

## Tag the npm package as `latest`

When the release is considered stable, promote it as `latest`:

- `npm dist-tag ls @xpack-dev-tools/ninja-build`
- `npm dist-tag add @xpack-dev-tools/ninja-build@1.11.1-2.1 latest`
- `npm dist-tag ls @xpack-dev-tools/ninja-build`

In case the previous version is not functional and needs to be unpublished:

- `npm unpublish @xpack-dev-tools/ninja-build@1.11.1-2.X`

## Update the Web

- in the `master` branch, merge the `develop` branch
- wait for the GitHub Pages build to complete
- the result is in <https://xpack.github.io/news/>
- remember the post URL, since it must be updated in the release page

## Create the final GitHub release

- go to the GitHub [Releases](https://github.com/xpack-dev-tools/ninja-build-xpack/releases/) page
- check the download counter, it should match the number of tests
- add a link to the Web page `[Continue reading »]()`; use an same blog URL
- remove the _tests only_ notice
- **disable** the **pre-release** button
- click the **Update Release** button

## Share on Twitter

- in a separate browser windows, open [TweetDeck](https://tweetdeck.twitter.com/)
- using the `@xpack_project` account
- paste the release name like **xPack Ninja Build v1.11.1-2 released**
- paste the link to the Web page
  [release](https://xpack.github.io/ninja-build/releases/)
- click the **Tweet** button

## Remove pre-release binaries

- go to <https://github.com/xpack-dev-tools/pre-releases/releases/tag/test/>
- remove the test binaries

## Clean the work area

Run the xPack action `trigger-workflow-deep-clean`, this
will remove the build folders on all supported platforms.

The tests results are available from the
[Actions](https://github.com/xpack-dev-tools/ninja-build-xpack/actions/) page.