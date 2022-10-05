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
  BRANDING="${DISTRO_NAME} ${APP_NAME} ${TARGET_MACHINE}"

  NINJA_VERSION="$(echo "${RELEASE_VERSION}" | sed -e 's|-.*||')"

  # xbb_set_binaries_install "${DEPENDENCIES_INSTALL_FOLDER_PATH}"
  xbb_set_binaries_install "${APPLICATION_INSTALL_FOLDER_PATH}"
  xbb_set_libraries_install "${DEPENDENCIES_INSTALL_FOLDER_PATH}"

  if [ "${TARGET_PLATFORM}" == "win32" ]
  then
    prepare_gcc_env "${XBB_CROSS_COMPILE_PREFIX}-"
  fi

  # Keep them in sync with combo archive content.
  if [[ "${RELEASE_VERSION}" =~ 1\.11\.[01]-* ]]
  then
    build_ninja "${RELEASE_VERSION}" # Pass the full xpack version
    # -------------------------------------------------------------------------
  else
    echo "Unsupported version ${RELEASE_VERSION}."
    exit 1
  fi
}

# -----------------------------------------------------------------------------
