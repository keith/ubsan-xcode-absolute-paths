#!/bin/bash

set -euo pipefail

# NOTE: Passing -fsanitize=undefined forces the dylib to link with the ubsan dylib
# which is required. We don't actually care about using ubsan for this dylib.

# NOTE: The name of this dylib is important to match this regex:
# https://github.com/llvm/llvm-project/blob/3a86931f56a9a1cd96a491119eb30fea76fbf9a7/lldb/source/Plugins/InstrumentationRuntime/UBSan/InstrumentationRuntimeUBSan.cpp#L232-L236
xcrun clang -dynamiclib -o libclang_rt.ubsan_hacks.dylib ubsan-hacks.c fishhook.c -fsanitize=undefined
