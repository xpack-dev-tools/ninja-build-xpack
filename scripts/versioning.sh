#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2022 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------

function build_versioned_components()
{
  # Don't use a comma since the regular expression
  # that processes this string in the Makefile, silently fails and the
  # bfdver.h file remains empty.
  # XBB_BRANDING="${XBB_APPLICATION_DISTRO_NAME} ${XBB_APPLICATION_NAME} ${XBB_TARGET_MACHINE}"

  XBB_NINJA_VERSION="$(echo "${XBB_RELEASE_VERSION}" | sed -e 's|-.*||')"

  # Keep them in sync with combo archive content.
  if [[ "${XBB_RELEASE_VERSION}" =~ 1\.11\.[01]-* ]]
  then
    xbb_set_binaries_install "${XBB_DEPENDENCIES_INSTALL_FOLDER_PATH}"
    xbb_set_libraries_install "${XBB_DEPENDENCIES_INSTALL_FOLDER_PATH}"

    if [ "${XBB_TARGET_PLATFORM}" == "darwin" ]
    then
      # https://ftp.gnu.org/pub/gnu/libiconv/
      build_libiconv "1.17" # "1.16"

      XBB_COREUTILS_INSTALL_REALPATH_ONLY="y"
      # https://ftp.gnu.org/gnu/coreutils/
      build_coreutils "9.1"
    fi

    xbb_set_binaries_install "${XBB_APPLICATION_INSTALL_FOLDER_PATH}"

    build_ninja "${XBB_RELEASE_VERSION}" # Pass the full xpack version
    # -------------------------------------------------------------------------
  else
    echo "Unsupported version ${XBB_RELEASE_VERSION}."
    exit 1
  fi
}

# -----------------------------------------------------------------------------
