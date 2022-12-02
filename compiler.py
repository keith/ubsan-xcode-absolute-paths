#!/usr/bin/env python3

import subprocess
import sys
import os

new_args = ["xcrun", "clang"]
for arg in sys.argv[1:]:
    if arg.endswith("main.mm"):
        new_args.append(os.path.relpath(arg))
    else:
        new_args.append(arg)

print(" ".join(new_args))
subprocess.check_call(new_args)
