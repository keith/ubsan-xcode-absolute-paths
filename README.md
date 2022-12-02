This repo has an example of how you can create a dylib to work around
issues with ubsan warnings with relative paths in Xcode.

Specifically if you have reproducible builds, there will be no absolute
paths in ubsan errors, but Xcode expects all file paths in ubsan errors
to be absolute in order for it to show annotations in the editor
pointing to the specific issues.

This heavily relies today's (Xcode 14.1) internals of ubsan + lldb.
