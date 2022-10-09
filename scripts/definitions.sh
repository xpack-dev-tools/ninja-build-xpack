# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# Warning: MUST NOT depend on $HOME or other environment variables.

# -----------------------------------------------------------------------------

# Used to display the application name.
APP_NAME=${APP_NAME:-"Ninja Build"}

# Used as part of file/folder paths.
APP_LC_NAME=${APP_LC_NAME:-"ninja-build"}

APP_DISTRO_NAME=${APP_DISTRO_NAME:-"xPack"}
APP_DISTRO_LC_NAME=${APP_DISTRO_LC_NAME:-"xpack"}
APP_DISTRO_TOP_FOLDER=${APP_DISTRO_TOP_FOLDER:-"xPacks"}

APP_DESCRIPTION="${APP_DISTRO_NAME} ${APP_NAME}"

# -----------------------------------------------------------------------------

GITHUB_ORG="${GITHUB_ORG:-"xpack-dev-tools"}"
GITHUB_REPO="${GITHUB_REPO:-"${APP_LC_NAME}-xpack"}"
GITHUB_PRE_RELEASES="${GITHUB_PRE_RELEASES:-"pre-releases"}"

NPM_PACKAGE="${NPM_PACKAGE:-"@xpack-dev-tools/${APP_LC_NAME}@next"}"

# -----------------------------------------------------------------------------
