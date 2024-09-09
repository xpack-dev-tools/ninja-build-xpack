# README.md

## CMake patch

Builds for Windows failed, and required to disable
`platform_supports_ninja_browse`.

Starting with 1.12.1 it was no longer used.

## cmd.exe

Initially a patch to invoke non .exe commands via cmd.exe was used.

```sh
git diff v1.12.1..v1.12.1-1-xpack --output ninja-1.12.1-1.git.patch
```

Starting with 1.12.1 it was no longer used.
