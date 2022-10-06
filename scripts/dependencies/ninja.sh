# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------

# https://github.com/ninja-build/ninja/wiki
# https://sourceforge.net/projects/msys2/files/REPOS/MSYS2/Sources/ninja-1.10.0-1.src.tar.gz/download

function build_ninja()
{
  local ninja_version="$1" # The full xpack version

  # https://ninja-build.org
  # https://github.com/ninja-build/ninja/archive/v1.10.0.tar.gz

  # https://github.com/xpack-dev-tools/ninja/tags/
  # https://github.com/xpack-dev-tools/ninja/archive/refs/tags/v1.11.0-1-xpack.tar.gz

  # https://github.com/archlinux/svntogit-community/blob/packages/ninja/trunk/PKGBUILD
  # https://archlinuxarm.org/packages/aarch64/ninja/files/PKGBUILD

  # https://github.com/Homebrew/homebrew-core/blob/master/Formula/ninja.rb

  local ninja_src_folder_name="ninja-${ninja_version}-xpack"
  local ninja_folder_name="ninja-${ninja_version}"

  # GitHub release archive.
  local ninja_github_archive="ninja-${ninja_version}-xpack.tar.gz"
  local ninja_github_url="https://github.com/xpack-dev-tools/ninja/archive/refs/tags/v${ninja_version}-xpack.tar.gz"

  mkdir -pv "${LOGS_FOLDER_PATH}/${ninja_folder_name}"

  local ninja_stamp_file_path="${STAMPS_FOLDER_PATH}/stamp-${ninja_folder_name}-installed"
  if [ ! -f "${ninja_stamp_file_path}" ]
  then

  cd "${SOURCES_FOLDER_PATH}"

    if [ ! -d "${SOURCES_FOLDER_PATH}/${ninja_src_folder_name}" ]
    then
      (
        cd "${SOURCES_FOLDER_PATH}"
        if [ ! -z ${NINJA_GIT_URL+x} ]
        then
          git_clone "${NINJA_GIT_URL}" "${NINJA_GIT_BRANCH}" \
              "${NINJA_GIT_COMMIT}" "${ninja_src_folder_name}"
        else
          download_and_extract "${ninja_github_url}" "${ninja_github_archive}" \
            "${ninja_src_folder_name}"
        fi
        # exit 1
      )
    fi

    (
      mkdir -p "${BUILD_FOLDER_PATH}/${ninja_folder_name}"
      cd "${BUILD_FOLDER_PATH}/${ninja_folder_name}"

      # xbb_activate_installed_dev

      # CPPFLAGS="${XBB_CPPFLAGS}"
      CFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_CFLAGS_NO_W} | sed -e 's|-O[0123s]||')"
      CXXFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_CXXFLAGS_NO_W} | sed -e 's|-O[0123s]||')"
      if [ "${TARGET_PLATFORM}" == "win32" ]
      then
        CFLAGS+=" -DUSE_WIN32_CMD_EXE_TO_CREATE_PROCESS"
        CXXFLAGS+=" -DUSE_WIN32_CMD_EXE_TO_CREATE_PROCESS"
      fi

      # Surprisingly, the Windows archive is longer with static libs.
      # LDFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_LDFLAGS_APP_STATIC_GCC} | sed -e 's|-O[0123s]||')"
      LDFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_LDFLAGS_APP} | sed -e 's|-O[0123s]||')"
      if [ "${TARGET_PLATFORM}" == "linux" ]
      then
        LDFLAGS+=" -Wl,-rpath,${LD_LIBRARY_PATH:-/non-empty-hack}"
      fi

      export CFLAGS
      export CXXFLAGS
      export LDFLAGS

      local build_type
      if [ "${IS_DEBUG}" == "y" ]
      then
        build_type="Debug"
      else
        build_type="Release"
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

          config_options+=("-DCMAKE_BUILD_TYPE=${build_type}")

          if [ "${TARGET_PLATFORM}" == "win32" ]
          then
            # The install of the ninja target requires changing an RPATH from the build
            # tree, but this is not supported with the Ninja generator
            config_options+=("-G" "Unix Makefiles")
            config_options+=("-DWIN32=ON")
          else
            config_options+=("-G" "Ninja")
          fi

          if [ "${IS_DEVELOP}" == "y" ]
          then
            config_options+=("-DCMAKE_VERBOSE_MAKEFILE=ON")
          fi

          config_options+=("-DCMAKE_INSTALL_PREFIX=${BINARIES_INSTALL_FOLDER_PATH}")

          run_verbose cmake \
            "${config_options[@]}" \
            \
            "${SOURCES_FOLDER_PATH}/${ninja_src_folder_name}" \

        ) 2>&1 | tee "${LOGS_FOLDER_PATH}/${ninja_folder_name}/cmake-output.txt"
      fi

      (
        echo
        echo "Running ninja build..."

        run_verbose cmake \
          --build . \
          --parallel ${JOBS} \
          --verbose \
          --config "${build_type}" \

        if [ "${TARGET_PLATFORM}" != "win32" ]
        then
          run_verbose ctest -vv
        fi

        echo
        # The install target is not functional:
        mkdir -pv "${BINARIES_INSTALL_FOLDER_PATH}/bin"
        if [ "${TARGET_PLATFORM}" == "win32" ]
        then
          install -v -m755 -c ninja.exe "${BINARIES_INSTALL_FOLDER_PATH}/bin"
        else
          install -v -m755 -c ninja "${BINARIES_INSTALL_FOLDER_PATH}/bin"
        fi

      ) 2>&1 | tee "${LOGS_FOLDER_PATH}/${ninja_folder_name}/build-output.txt"

      copy_license \
        "${SOURCES_FOLDER_PATH}/${ninja_src_folder_name}" \
        "${ninja_folder_name}"

    )

    touch "${ninja_stamp_file_path}"

  else
    echo "Component wine already installed."
  fi

  tests_add "test_ninja" "${BINARIES_INSTALL_FOLDER_PATH}/bin"
}

# -----------------------------------------------------------------------------

function test_ninja()
{
  local test_bin_path="$1"

  (
    echo
    echo "Checking the ninja shared libraries..."
    show_libs "${test_bin_path}/ninja"

    echo
    echo "Checking if ninja starts..."

    run_app "${test_bin_path}/ninja" --version

    run_app "${test_bin_path}/ninja" --help || true
  )
}

# -----------------------------------------------------------------------------
