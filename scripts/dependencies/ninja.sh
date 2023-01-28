# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------

# https://ninja-build.org
# https://github.com/ninja-build/ninja/wiki
# https://sourceforge.net/projects/msys2/files/REPOS/MSYS2/Sources/ninja-1.10.0-1.src.tar.gz/download

# https://github.com/ninja-build/ninja/archive/v1.10.0.tar.gz

# https://github.com/xpack-dev-tools/ninja/tags/
# https://github.com/xpack-dev-tools/ninja/archive/refs/tags/v1.11.0-1-xpack.tar.gz

# https://github.com/archlinux/svntogit-community/blob/packages/ninja/trunk/PKGBUILD
# https://archlinuxarm.org/packages/aarch64/ninja/files/PKGBUILD

# https://github.com/Homebrew/homebrew-core/blob/master/Formula/ninja.rb

# -----------------------------------------------------------------------------

function ninja_build()
{
  echo_develop
  echo_develop "[${FUNCNAME[0]} $@]"

  local ninja_xpack_version="$1" # The full xpack version

  local ninja_version="$(xbb_strip_version_pre_release "${ninja_xpack_version}")"

  local ninja_src_folder_name="ninja-${ninja_xpack_version}-xpack"
  local ninja_folder_name="ninja-${ninja_version}"

  # GitHub release archive.
  local ninja_github_archive="ninja-${ninja_xpack_version}-xpack.tar.gz"
  local ninja_github_url="https://github.com/xpack-dev-tools/ninja/archive/refs/tags/v${ninja_xpack_version}-xpack.tar.gz"

  mkdir -pv "${XBB_LOGS_FOLDER_PATH}/${ninja_folder_name}"

  local ninja_stamp_file_path="${XBB_STAMPS_FOLDER_PATH}/stamp-${ninja_folder_name}-installed"
  if [ ! -f "${ninja_stamp_file_path}" ]
  then

    mkdir -pv "${XBB_SOURCES_FOLDER_PATH}"
    cd "${XBB_SOURCES_FOLDER_PATH}"

    if [ ! -d "${XBB_SOURCES_FOLDER_PATH}/${ninja_src_folder_name}" ]
    then
      (
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
      mkdir -pv "${XBB_BUILD_FOLDER_PATH}/${ninja_folder_name}"
      cd "${XBB_BUILD_FOLDER_PATH}/${ninja_folder_name}"

      # xbb_activate_dependencies_dev

      # CPPFLAGS="${XBB_CPPFLAGS}"
      CFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_CFLAGS_NO_W} | sed -e 's|-O[0123s]||')"
      CXXFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_CXXFLAGS_NO_W} | sed -e 's|-O[0123s]||')"
      if [ "${XBB_HOST_PLATFORM}" == "win32" ]
      then
        CFLAGS+=" -DUSE_WIN32_CMD_EXE_TO_CREATE_PROCESS"
        CXXFLAGS+=" -DUSE_WIN32_CMD_EXE_TO_CREATE_PROCESS"
      fi

      # Surprisingly, the Windows archive is longer with static libs, but the
      # Linux archives are significantly smaller, so static wins this time.
      LDFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_LDFLAGS_APP_STATIC_GCC} | sed -e 's|-O[0123s]||')"
      # LDFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_LDFLAGS_APP} | sed -e 's|-O[0123s]||')"

      xbb_adjust_ldflags_rpath

      export CFLAGS
      export CXXFLAGS
      export LDFLAGS

      local build_type
      if [ "${XBB_IS_DEBUG}" == "y" ]
      then
        build_type="Debug"
      else
        build_type="Release"
      fi

      if true # [ ! -f "CMakeCache.txt" ]
      then
        (
          xbb_show_env_develop

          echo
          echo "Running ninja configure..."

          config_options=()

          config_options+=("-DCMAKE_BUILD_TYPE=${build_type}")

          if [ "${XBB_HOST_PLATFORM}" == "win32" ]
          then
            # The install of the ninja target requires changing an RPATH from the build
            # tree, but this is not supported with the Ninja generator
            config_options+=("-G" "Unix Makefiles")

            config_options+=("-DCMAKE_SYSTEM_NAME=Windows")
          else
            config_options+=("-G" "Ninja")
          fi

          if [ "${XBB_IS_DEVELOP}" == "y" ]
          then
            config_options+=("-DCMAKE_VERBOSE_MAKEFILE=ON")
          fi

          config_options+=("-DCMAKE_INSTALL_PREFIX=${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}")

          if [ "${XBB_HOST_PLATFORM}" == "darwin" ]
          then
            config_options+=("-DCMAKE_OSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET}")
          fi

          run_verbose cmake \
            "${config_options[@]}" \
            \
            "${XBB_SOURCES_FOLDER_PATH}/${ninja_src_folder_name}" \

        ) 2>&1 | tee "${XBB_LOGS_FOLDER_PATH}/${ninja_folder_name}/cmake-output-$(ndate).txt"
      fi

      (
        echo
        echo "Running ninja build..."

        if [ "${XBB_IS_DEVELOP}" == "y" ]
        then
          run_verbose cmake \
            --build . \
            --parallel ${XBB_JOBS} \
            --verbose \
            --config "${build_type}"
        else
          run_verbose cmake \
            --build . \
            --parallel ${XBB_JOBS} \
            --config "${build_type}"
        fi

        if [ "${XBB_HOST_PLATFORM}" != "win32" ]
        then
          run_verbose ctest -vv
        fi

        echo
        # The install target is not functional:
        mkdir -pv "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/bin"
        if [ "${XBB_HOST_PLATFORM}" == "win32" ]
        then
          install -v -m755 -c ninja.exe "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/bin"
        else
          install -v -m755 -c ninja "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/bin"
        fi

      ) 2>&1 | tee "${XBB_LOGS_FOLDER_PATH}/${ninja_folder_name}/build-output-$(ndate).txt"

      copy_license \
        "${XBB_SOURCES_FOLDER_PATH}/${ninja_src_folder_name}" \
        "${ninja_folder_name}"

    )

    mkdir -pv "${XBB_STAMPS_FOLDER_PATH}"
    touch "${ninja_stamp_file_path}"

  else
    echo "Component ninja already installed"
  fi

  tests_add "ninja_test" "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/bin"
}

# -----------------------------------------------------------------------------

function ninja_test()
{
  local test_bin_path="$1"

  (
    echo
    echo "Checking the ninja shared libraries..."
    show_host_libs "${test_bin_path}/ninja"

    echo
    echo "Checking if ninja starts..."

    run_host_app_verbose "${test_bin_path}/ninja" --version

    run_host_app_verbose "${test_bin_path}/ninja" --help || true

    run_host_app_verbose "${test_bin_path}/ninja" -t list

    rm -rf "${XBB_TESTS_FOLDER_PATH}/ninja"
    mkdir -pv "${XBB_TESTS_FOLDER_PATH}/ninja"; cd "${XBB_TESTS_FOLDER_PATH}/ninja"

    # Note: __EOF__ is quoted to prevent substitutions here.
    cat <<'__EOF__' > build.ninja
cflags = -Wall
rule cc
  command = echo gcc $cflags -c $in -o $out
build foo.o: cc foo.c
__EOF__

    touch foo.c

    run_host_app_verbose "${test_bin_path}/ninja" -t targets
    run_host_app_verbose "${test_bin_path}/ninja" -t rules
    run_host_app_verbose "${test_bin_path}/ninja" -t commands

    run_host_app_verbose "${test_bin_path}/ninja"
  )
}

# -----------------------------------------------------------------------------
