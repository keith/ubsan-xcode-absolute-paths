#!/bin/bash

set -euo pipefail
set -x

name=libclang_rt.ubsan_hacks.dylib
xcrun clang -install_name @rpath/$name -dynamiclib -o $name dylib.c ub-paths/fishhook.c -I ub-paths -fsanitize=undefined
