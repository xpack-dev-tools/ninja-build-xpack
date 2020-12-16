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

  local ninja_patch="${ninja_folder_name}.patch"

  # GitHub release archive.
  local ninja_archive_file_name="${ninja_src_folder_name}.tar.gz"
  local ninja_url="https://github.com/ninja-build/ninja/archive/v${ninja_version}.tar.gz"

  cd "${SOURCES_FOLDER_PATH}"

  download_and_extract "${ninja_url}" "${ninja_archive_file_name}" \
    "${ninja_src_folder_name}" "${ninja_patch}"

  (
    mkdir -p "${BUILD_FOLDER_PATH}/${ninja_folder_name}"
    cd "${BUILD_FOLDER_PATH}/${ninja_folder_name}"

    mkdir -pv "${LOGS_FOLDER_PATH}/${ninja_folder_name}"

    xbb_activate
    # xbb_activate_installed_dev

    if false # [ "${TARGET_PLATFORM}" == "win32" ]
    then
      prepare_gcc_env "${CROSS_COMPILE_PREFIX}-"
    fi

    # CPPFLAGS="${XBB_CPPFLAGS}"
    CFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_CFLAGS_NO_W} | sed -e 's|-O[0123s]||')"
    CXXFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_CFLAGS_NO_W} | sed -e 's|-O[0123s]||')"
    LDFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_LDFLAGS_APP_STATIC_GCC} | sed -e 's|-O[0123s]||')"
    if [ "${TARGET_PLATFORM}" == "linux" ]
    then
      LDFLAGS+=" -Wl,-rpath,${LD_LIBRARY_PATH}"
    fi      
    if [ "${IS_DEVELOP}" == "y" ]
    then
      LDFLAGS+=" -v"
    fi

    export CFLAGS
    export CXXFLAGS
    export LDFLAGS

    env | sort

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
        echo
        echo "Running ninja configure..."

        config_options=()

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

      #  --parallel ${JOBS} \
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

      prepare_app_libraries "${APP_PREFIX}/bin/ninja"

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
  run_app "${APP_PREFIX}/bin/ninja" --version

  run_app "${APP_PREFIX}/bin/ninja" --help || true
}

# -----------------------------------------------------------------------------
