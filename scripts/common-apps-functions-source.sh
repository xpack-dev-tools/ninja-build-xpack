# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# Helper script used in the second edition of the xPack build
# scripts. As the name implies, it should contain only functions and
# should be included with 'source' by the container build scripts.

# -----------------------------------------------------------------------------

# https://github.com/ninja-build/ninja/wiki
# https://sourceforge.net/projects/msys2/files/REPOS/MSYS2/Sources/ninja-1.10.0-1.src.tar.gz/download

function build_ninja()
{
  local ninja_version="$1"

  # https://ninja-build.org
  # https://github.com/ninja-build/ninja/archive/v1.10.0.tar.gz

  # https://archlinuxarm.org/packages/aarch64/ninja/files/PKGBUILD

  local ninja_src_folder_name="ninja-${ninja_version}"
  local ninja_folder_name="${ninja_src_folder_name}"

  mkdir -pv "${LOGS_FOLDER_PATH}/${ninja_folder_name}"

  cd "${SOURCES_FOLDER_PATH}"

  if [ ! -d "${SOURCES_FOLDER_PATH}/${ninja_src_folder_name}" ]
  then
    (
      cd "${SOURCES_FOLDER_PATH}"
      git_clone "${NINJA_GIT_URL}" "${NINJA_GIT_BRANCH}" \
          "${NINJA_GIT_COMMIT}" "${ninja_src_folder_name}"
    )
  fi

  (
    mkdir -p "${BUILD_FOLDER_PATH}/${ninja_folder_name}"
    cd "${BUILD_FOLDER_PATH}/${ninja_folder_name}"

    # xbb_activate_installed_dev

    # CPPFLAGS="${XBB_CPPFLAGS}"
    CFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_CFLAGS_NO_W} | sed -e 's|-O[0123s]||')"
    CXXFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_CFLAGS_NO_W} | sed -e 's|-O[0123s]||')"
    if [ "${TARGET_PLATFORM}" == "win32" ]
    then
      CFLAGS+=" -DUSE_WIN32_CMD_EXE_TO_CREATE_PROCESS"
      CXXFLAGS+=" -DUSE_WIN32_CMD_EXE_TO_CREATE_PROCESS"
    fi
    LDFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_LDFLAGS_APP_STATIC_GCC} | sed -e 's|-O[0123s]||')"
    if [ "${TARGET_PLATFORM}" == "linux" ]
    then
      LDFLAGS+=" -Wl,-rpath,${LD_LIBRARY_PATH}"
    fi

    export CFLAGS
    export CXXFLAGS
    export LDFLAGS

    local build_type
    if [ "${IS_DEBUG}" == "y" ]
    then
      build_type=Debug
    else
      build_type=Release
    fi

    if true # [ ! -f "CMakeCache.txt" ]
    then
      (
        if [ "${IS_DEVELOP}" == "y" ]
        then
          env | sort
        fi

        echo
        echo "Running ninja configure..."

        config_options=()

        # With ninja, the windows build fails with:
        # The install of the ninja target requires changing an RPATH from the build
        # tree, but this is not supported with the Ninja generator
        config_options+=("-G" "Unix Makefiles")

        config_options+=("-DCMAKE_BUILD_TYPE=${build_type}")

        if [ "${TARGET_PLATFORM}" == "win32" ]
        then
            config_options+=("-DWIN32=ON")
        fi

        if [ "${IS_DEBUG}" == "y" ]
        then
          config_options+=("-DCMAKE_VERBOSE_MAKEFILE=ON")
        fi

        config_options+=("-DCMAKE_INSTALL_PREFIX=${APP_PREFIX}")

        run_verbose_timed cmake \
          ${config_options[@]} \
          \
          "${SOURCES_FOLDER_PATH}/${ninja_src_folder_name}" \

      ) 2>&1 | tee "${LOGS_FOLDER_PATH}/${ninja_folder_name}/cmake-output.txt"
    fi

    (
      echo
      echo "Running ninja build..."

      run_verbose_timed cmake \
        --build . \
        --parallel ${JOBS} \
        --verbose \
        --config "${build_type}" \

      if [ "${TARGET_PLATFORM}" != "win32" ]
      then
        run_verbose_timed ctest -vv
      fi

      # The install target is not funtional:
      mkdir -pv "${APP_PREFIX}/bin"
      if [ "${TARGET_PLATFORM}" == "win32" ]
      then
        install -v -m755 -c ninja.exe "${APP_PREFIX}/bin"
      else
        install -v -m755 -c ninja "${APP_PREFIX}/bin"
      fi

    ) 2>&1 | tee "${LOGS_FOLDER_PATH}/${ninja_folder_name}/build-output.txt"

    copy_license \
      "${SOURCES_FOLDER_PATH}/${ninja_src_folder_name}" \
      "${ninja_folder_name}"

  )

  tests_add "test_ninja"
}

# -----------------------------------------------------------------------------

function test_ninja()
{
  if [ -d "xpacks/.bin" ]
  then
    NINJA="xpacks/.bin/ninja"
  elif [ -d "${APP_PREFIX}/bin" ]
  then
    NINJA="${APP_PREFIX}/bin/ninja"
  else
    echo "Wrong folder."
    exit 1
  fi

  echo
  echo "Checking the ninja shared libraries..."
  show_libs "${NINJA}"

  echo
  echo "Checking if ninja starts..."

  run_app "${NINJA}" --version

  run_app "${NINJA}" --help || true
}

# -----------------------------------------------------------------------------
