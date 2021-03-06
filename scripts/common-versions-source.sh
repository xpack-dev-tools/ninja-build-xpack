# -----------------------------------------------------------------------------
# This file is part of the xPacks distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software 
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# Helper script used in the second edition of the GNU MCU Eclipse build 
# scripts. As the name implies, it should contain only functions and 
# should be included with 'source' by the container build scripts.

# -----------------------------------------------------------------------------

function build_versions()
{
  # The \x2C is a comma in hex; without this trick the regular expression
  # that processes this string in the Makefile, silently fails and the 
  # bfdver.h file remains empty.
  BRANDING="${BRANDING}\x2C ${TARGET_MACHINE}"

  # NINJA_BUILD_GIT_BRANCH=${NINJA_BUILD_GIT_BRANCH:-"master"}
  # NINJA_BUILD_GIT_COMMIT=${NINJA_BUILD_GIT_COMMIT:-"HEAD"}

  NINJA_VERSION="$(echo "${RELEASE_VERSION}" | sed -e 's|-[0-9]*||')"

  # Keep them in sync with combo archive content.
  if [[ "${RELEASE_VERSION}" =~ 1\.10\.[2]-* ]]
  then

    if [ "${RELEASE_VERSION}" == "1.10.2-2" ]
    then
      NINJA_GIT_URL=${NINJA_GIT_URL:-"https://github.com/xpack-dev-tools/ninja.git"}
      NINJA_GIT_BRANCH=${NINJA_GIT_BRANCH:-"xpack"}
      NINJA_GIT_COMMIT=${NINJA_GIT_COMMIT:-"73218c896d51b91a4654531e90bf9a277bdf0300"}
    elif [ "${RELEASE_VERSION}" == "1.10.2-3" ]
    then
      NINJA_GIT_URL=${NINJA_GIT_URL:-"https://github.com/xpack-dev-tools/ninja.git"}
      NINJA_GIT_BRANCH=${NINJA_GIT_BRANCH:-"xpack"}
      NINJA_GIT_COMMIT=${NINJA_GIT_COMMIT:-"148d49dd50c9d126bbcb509c1082ac8ef8dcf76a"}
    else
      echo "Unsupported version"
      exit 1
    fi

    # -------------------------------------------------------------------------
    
    build_ninja "${NINJA_VERSION}"

    # -------------------------------------------------------------------------
  elif [[ "${RELEASE_VERSION}" =~ 1\.10\.[01]-* ]]
  then

    # -------------------------------------------------------------------------
    
    README_OUT_FILE_NAME=${README_OUT_FILE_NAME:-"README-${RELEASE_VERSION}.md"}
    
    build_ninja "${NINJA_VERSION}"

    # -------------------------------------------------------------------------
  else
    echo "Unsupported version ${RELEASE_VERSION}."
    exit 1
  fi
}

# -----------------------------------------------------------------------------
