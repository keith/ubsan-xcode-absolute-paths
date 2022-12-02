#include <stdio.h>
#include <dlfcn.h>
#include <stdlib.h>
#include "fishhook.h"

void (*orig___ubsan_on_report)(void);

void __ubsan_on_report(void) {
    printf("my report 2\n");
}


void my__ubsan_on_report(void) {
    printf("my report\n");
//    orig___ubsan_on_report();
    __ubsan_on_report();
}

typedef void (*foo_t)(const char **OutIssueKind,
    const char **OutMessage, const char **OutFilename, unsigned *OutLine,
                                unsigned *OutCol, char **OutMemoryAddr);


__attribute__((visibility("default")))
void
__ubsan_get_current_report_data(const char **OutIssueKind,
    const char **OutMessage, const char **OutFilename, unsigned *OutLine,
                                unsigned *OutCol, char **OutMemoryAddr)
{

//    const char *foo = malloc(10);
//    foo = "lol";
//    OutMessage = &foo;
    printf("mine!\n");

    foo_t realFoo = (foo_t)dlsym(RTLD_NEXT, "__ubsan_get_current_report_data");
    printf("mine! %p\n", realFoo);

    realFoo(OutIssueKind, OutMessage, OutFilename, OutLine, OutCol, OutMemoryAddr);

    printf("the out filename is '%s'\n", *OutFilename);
    *OutFilename = "/Users/ksmiley/Downloads/ub-paths/ub-paths/main.c";
    printf("the out filename is now '%s'\n", *OutFilename);

//    abort();
//    fprintf(stderr, "mine firstttttttttt\n");
//
//    orig__ubsan_get_current_report_data(OutIssueKind, OutMessage, OutFilename, OutLine, OutCol, OutMemoryAddr);
//
//    FILE *fp = fopen("/tmp/reporter.txt", "w");
//    if (fp == NULL)
//    {
////        printf("Error opening the file %s", filename);
////        return -1;
//        return;
//    }
//    // write to the text file
//    for (int i = 0; i < 10; i++)
//        fprintf(fp, "reporter 2 is the line #%d\n", i + 1);
//
//    // close the file
//    fclose(fp);

}

__attribute__((constructor))
  void foo() {

        rebind_symbols((struct rebinding[2]){
        {"__ubsan_on_report", (void *)my__ubsan_on_report, (void * *)&orig___ubsan_on_report},
//        {"__ubsan_get_current_report_data", (void *)my___ubsan_get_current_report_data, (void * *)&orig___ubsan_get_current_report_data}
    }, 1);

    printf("loading\n");
  }

//__attribute__((visibility("default")))
//void __ubsan_on_report(void) {
//    printf("my report\n");
//}


// __attribute__((visibility("default")))
// void
// __ubsan_get_current_report_data(const char **OutIssueKind,
//     const char **OutMessage, const char **OutFilename, unsigned *OutLine,
//                                 unsigned *OutCol, char **OutMemoryAddr)
// {
//     printf("mine firstttttttttt\n");
// }

