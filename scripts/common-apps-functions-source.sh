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

function do_ninja_bootstrap()
{
  local ninja_version="$1"

  # https://ninja-build.org
  # https://github.com/ninja-build/ninja/archive/v1.10.0.tar.gz

  # https://archlinuxarm.org/packages/aarch64/ninja/files/PKGBUILD

  local ninja_src_folder_name="ninja-${ninja_version}"
  local ninja_folder_name="${ninja_src_folder_name}"

  # GitHub release archive.
  local ninja_archive_file_name="${ninja_src_folder_name}.tar.gz"
  local ninja_url="https://github.com/ninja-build/ninja/archive/v${ninja_version}.tar.gz"

  # In-source build
  cd "${BUILD_FOLDER_PATH}"

  download_and_extract "${ninja_url}" "${ninja_archive_file_name}" \
    "${ninja_src_folder_name}"

  (
    cd "${BUILD_FOLDER_PATH}/${ninja_folder_name}"

    xbb_activate

    if [ "${TARGET_PLATFORM}" == "linux" ]
    then
      ninja_host="linux"
      ninja_platform="linux"
    elif [ "${TARGET_PLATFORM}" == "darwin" ]
    then
      ninja_host="darwin"
      ninja_platform="darwin"
    elif [ "${TARGET_PLATFORM}" == "win32" ]
    then
      ninja_host="linux"
      ninja_platform="mingw"

      CC=${CROSS_COMPILE_PREFIX}-gcc
      CXX=${CROSS_COMPILE_PREFIX}-g++
      AR=${CROSS_COMPILE_PREFIX}-ar
    fi

    # export CPPFLAGS="${XBB_CPPFLAGS}"
    export CFLAGS="${XBB_CPPFLAGS} ${XBB_CFLAGS}"
    export CXXFLAGS="${XBB_CPPFLAGS} ${XBB_CXXFLAGS}"
    # export LDFLAGS="${XBB_CPPFLAGS} ${XBB_LDFLAGS_APP_STATIC_GCC} -v"
    export LDFLAGS="${XBB_CPPFLAGS} ${XBB_LDFLAGS_APP} -v"

env | sort

    (
      echo
      echo "Running ninja bootstrap..."

      ./configure.py --help

      echo "Bootstraping... Patience..."
      
      ./configure.py \
        --verbose \
        --bootstrap \
        --with-python="$(which python2)" \
        --platform="${ninja_platform}" \
        --host="${ninja_host}" \

      mkdir -p "${APP_PREFIX}/bin"
      /usr/bin/install -v -m755 -c ninja "${APP_PREFIX}/bin"

      prepare_app_libraries "${APP_PREFIX}/bin/ninja"

    ) 2>&1 | tee "${LOGS_FOLDER_PATH}/build-ninja-output.txt"

    copy_license \
      "${BUILD_FOLDER_PATH}/${ninja_src_folder_name}" \
      "${ninja_folder_name}"
  )

}

function do_ninja()
{
  local ninja_version="$1"

  # https://ninja-build.org
  # https://github.com/ninja-build/ninja/archive/v1.10.0.tar.gz

  # https://archlinuxarm.org/packages/aarch64/ninja/files/PKGBUILD

  local ninja_src_folder_name="ninja-${ninja_version}"
  local ninja_folder_name="${ninja_src_folder_name}"

  # GitHub release archive.
  local ninja_archive_file_name="${ninja_src_folder_name}.tar.gz"
  local ninja_url="https://github.com/ninja-build/ninja/archive/v${ninja_version}.tar.gz"

  cd "${SOURCES_FOLDER_PATH}"

  download_and_extract "${ninja_url}" "${ninja_archive_file_name}" \
    "${ninja_src_folder_name}"

  (
    mkdir -p "${BUILD_FOLDER_PATH}/${ninja_folder_name}"
    cd "${BUILD_FOLDER_PATH}/${ninja_folder_name}"

    mkdir -pv "${LOGS_FOLDER_PATH}/${ninja_folder_name}"

    xbb_activate

    if [ "${TARGET_PLATFORM}" == "win32" ]
    then
      CC=${CROSS_COMPILE_PREFIX}-gcc
      CXX=${CROSS_COMPILE_PREFIX}-g++
      AR=${CROSS_COMPILE_PREFIX}-ar
    fi

    # export CPPFLAGS="${XBB_CPPFLAGS}"
    export CFLAGS="${XBB_CPPFLAGS} ${XBB_CFLAGS}"
    export CXXFLAGS="${XBB_CPPFLAGS} ${XBB_CXXFLAGS}"
    export LDFLAGS="${XBB_CPPFLAGS} ${XBB_LDFLAGS_APP_STATIC_GCC} -v"

    env | sort

    local build_type
    if [ "${IS_DEBUG}" == "y" ]
    then
      build_type=Debug
    else
      build_type=Release
    fi

    if [ ! -f "CMakeCache.txt" ]
    then
      (
        echo
        echo "Running ninja configure..."

        cmake \
          -G Ninja \
          -DCMAKE_BUILD_TYPE="${build_type}" \
          "${SOURCES_FOLDER_PATH}/${ninja_src_folder_name}"

      ) 2>&1 | tee "${LOGS_FOLDER_PATH}/${ninja_folder_name}/cmake-output.txt"
    fi

    (
      echo
      echo "Running ninja build..."

      cmake \
        --build . \
        --parallel \
        --config "${build_type}" \

      mkdir -p "${APP_PREFIX}/bin"
      /usr/bin/install -v -m755 -c ninja "${APP_PREFIX}/bin"

      prepare_app_libraries "${APP_PREFIX}/bin/ninja"

    ) 2>&1 | tee "${LOGS_FOLDER_PATH}/${ninja_folder_name}/build-output.txt"

    copy_license \
      "${SOURCES_FOLDER_PATH}/${ninja_src_folder_name}" \
      "${ninja_folder_name}"

  )

}

# -----------------------------------------------------------------------------

function run_ninja()
{
  run_app "${APP_PREFIX}/bin/ninja" --version
}

# -----------------------------------------------------------------------------
