#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "fishhook.h"

void (*orig___ubsan_on_report)(void);

void __ubsan_on_report(void) {
  // This report function does nothing but internally lldb sets a breakpoint on
  // it and when that breakpoint fires it collects the info about the ubsan
  // violation. It _has_ to retain the original name because otherwise lldb will
  // choose the real ubsan library for the breakpoint, and the module associated
  // with the breakpoint is how it decides where to call the reporter function
  // from.

  // Order of operations:
  // 1. Library is loaded
  // 2. lldb sets a breakpoint on the first instance of __ubsan_on_report it
  //    finds (has to be this one)
  // 3. We rebind the original __ubsan_on_report to this function
  // 4. When ubsan calls the original function, it's redirected here, then the
  //    breakpoint is hit in this module instead of the real ubsan library
}

typedef void (*reporter_t)(const char **OutIssueKind, const char **OutMessage,
                           const char **OutFilename, unsigned *OutLine,
                           unsigned *OutCol, char **OutMemoryAddr);

// This function has to match the name and signature from the real ubsan
// library. It is called in response to a lldb breakpoint on __ubsan_on_report
// and is chosen since it's in the same module as that function (see above).
void __ubsan_get_current_report_data(const char **OutIssueKind,
                                     const char **OutMessage,
                                     const char **OutFilename,
                                     unsigned *OutLine, unsigned *OutCol,
                                     char **OutMemoryAddr) {
  reporter_t real_reporter =
      (reporter_t)dlsym(RTLD_NEXT, "__ubsan_get_current_report_data");
  if (real_reporter == NULL) {
    fprintf(stderr, "dlsym failed, this likely means the ubsan hacks library "
                    "doesn't depend on ubsan, it needs to link against it\n");
    abort();
  }

  real_reporter(OutIssueKind, OutMessage, OutFilename, OutLine, OutCol,
                OutMemoryAddr);
  if (strlen(*OutFilename) < 1 || strncmp("/", *OutFilename, 1) == 0) {
    return;
  }

  const char *srcroot = getenv("SRCROOT");
  if (srcroot == NULL) {
    fprintf(stderr, "$SRCROOT not set for ubsan hacks, launch the tests with "
                    "it in the environment to fix paths\n");
    return;
  }

  char *new_filename = malloc(1024);
  strcpy(new_filename, srcroot);
  strcat(new_filename, "/");
  strcat(new_filename, *OutFilename);
  *OutFilename = new_filename;
}

__attribute__((constructor)) void setup_hacks() {
  rebind_symbols(
      (struct rebinding[2]){
          {"__ubsan_on_report", (void *)__ubsan_on_report,
           (void **)&orig___ubsan_on_report},
      },
      1);
}
