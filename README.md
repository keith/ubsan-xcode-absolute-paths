# Summary

This repo has an example of how you can create a dylib to work around
issues with ubsan warnings with relative paths in Xcode.

Specifically if you have reproducible builds, there will be no absolute
paths in ubsan errors, but Xcode expects all file paths in ubsan errors
to be absolute in order for it to show annotations in the editor
pointing to the specific issues.

Warning: this heavily relies today's (Xcode 14.1) internals of ubsan +
lldb.

## How to use

1. Compile `ubsan-hacks.c` into `libclang_rt.ubsan_hacks.dylib` (see
   `build-hacks-dylib.sh` for an example)
2. Run your binary with `SRCROOT=$(SRCROOT)` in the environment to
   provide the root path for source files
3. Insert that library at runtime with
   `DYLD_INSERT_LIBRARIES=/path/to/dylib`
4. When ubsan errors are produced, Xcode annotations should work
   correctly

Note: if you're not attaching lldb in Xcode you don't need this since
Xcode doesn't show annotations at all in that case.

Note: the stack trace of the ubsan errors include a few extra stack
frames because lldb attempts to filter these out based on a heuristic
that we're violating.

## How it works

Ubsan's errors include file paths from your binary by referencing
instances of
[`OverflowData`](https://github.com/llvm/llvm-project/blob/3a86931f56a9a1cd96a491119eb30fea76fbf9a7/compiler-rt/lib/ubsan/ubsan_handlers.h#L52-L55)
in your binary. These paths come from the paths on the command line, and
are relative in the case you pass relative paths to the compiler.

When ubsan produces errors at runtime, its monitoring mechanism calls
`__ubsan_on_report`, which lldb sets an internal breakpoint for (you can
see internal breakpoints with `br list -i`). lldb then calls ubsan's
`__ubsan_get_current_report_data` function to get the specific
information of the current report. The instance of
`__ubsan_get_current_report_data` it calls, and the `__ubsan_on_report`
must reside in the same module.

This hack works by:

1. Tricking lldb into thinking this library is ubsan so it sets the
   `__ubsan_on_report` breakpoint in our library instead of in the
   actual ubsan library
2. Once ubsan finds an error, since the breakpoint is in our module, it
   then calls `__ubsan_get_current_report_data` in our module instead.
   We use this hook to call the original function, and fixup the path to
   be absolute if it's not already.
