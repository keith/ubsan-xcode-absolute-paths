#!/usr/bin/env python3

# NOTE: This just exists to simplify getting relative paths in the binary. If
# you're using a build system that passes file paths relatively you already get
# this (and if you don't you shouldn't need this hack at all)

import subprocess
import sys
import os

new_args = ["xcrun", "clang"]
for arg in sys.argv[1:]:
    if arg.endswith((".h", ".m", ".c")):
        new_args.append(os.path.relpath(arg))
    else:
        new_args.append(arg)

print(" ".join(new_args))
subprocess.check_call(new_args)
