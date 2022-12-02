//
//  main.m
//  ub-paths
//
//  Created by Keith Smiley on 11/30/22.
//

#import <Foundation/Foundation.h>
#import "fishhook.h"

#include <stdio.h>
#include <unistd.h>
#include <dlfcn.h>
#include <stdio.h>
#import <mach/mach.h>
#include <sys/utsname.h>
#import <mach-o/loader.h>
#import <sys/mman.h>
#import <pthread.h>
#include <stdio.h>
#include <dlfcn.h>
#include <stdio.h>
#include <unistd.h>
#include <strings.h>
#include <sys/types.h>
#include <mach/error.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/sysctl.h>
#include <dlfcn.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <pthread.h>

#define DYLD_INTERPOSE(_replacment,_replacee) \
   __attribute__((used)) static struct{ const void* replacment; const void* replacee; } _interpose_##_replacee \
            __attribute__ ((section ("__DATA,__interpose"))) = { (const void*)(unsigned long)&_replacment, (const void*)(unsigned long)&_replacee };


struct dyld_interpose_tuple {
    const void* replacement;
    const void* replacee;
};

extern const struct mach_header __dso_handle;
extern void dyld_dynamic_interpose(const struct mach_header* mh, const struct dyld_interpose_tuple array[], size_t count);


//void (*orig___sanitizer_on_print)(const char *str);
//
//void my__sanitizer_on_print(const char *str) {
//    const char *srcroot = getenv("SRCROOT");
//    if (srcroot != NULL && strstr(str, "runtime error:") != NULL) {
//        printf("%s/%s\n", srcroot, str);
//    }
//}
//
//void (*orig___sanitizer_report_error_summary)(const char *error_summary);
void (*orig___ubsan_on_report)(void);

//
//extern "C" void __ubsan_get_current_report_data(const char **OutIssueKind,
//    const char **OutMessage, const char **OutFilename, unsigned *OutLine,
//    unsigned *OutCol, char **OutMemoryAddr);

void (*orig___ubsan_get_current_report_data)(const char **OutIssueKind,
    const char **OutMessage, const char **OutFilename, unsigned *OutLine,
    unsigned *OutCol, char **OutMemoryAddr);


//    __attribute__((visibility("hidden")))
namespace __sanitizer {
    const char *myStripPathPrefix(const char *filepath,
                                const char *strip_path_prefix) {
        printf("lol??????\n");
        return nullptr;
    }
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
    *OutFilename = "/Users/ksmiley/Downloads/ub-paths/ub-paths/main.mm";
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

//__attribute__((init_priority(200))) static int *lol = &__ubsan_get_current_report_data;
//
//
//
//void my__sanitizer_report_error_summary(const char *error_summary) {
//    printf("lol here\n");
////    printf("%s\n", error_summary);
//}
//
//void __ubsan_get_current_report_data(const char **OutIssueKind,
//    const char **OutMessage, const char **OutFilename, unsigned *OutLine,
//    unsigned *OutCol, char **OutMemoryAddr);
//
//

extern "C"
void my___ubsan_get_current_report_data(const char **OutIssueKind,
                                const char **OutMessage,
                                const char **OutFilename, unsigned *OutLine,
                                unsigned *OutCol, char **OutMemoryAddr) {
    printf("in my reporter 2\n");
//
    FILE *fp = fopen("/tmp/reporter.txt", "w");
    if (fp == NULL)
    {
//        printf("Error opening the file %s", filename);
//        return -1;
        return;
    }
    // write to the text file
    for (int i = 0; i < 10; i++)
        fprintf(fp, "This is the line #%d\n", i + 1);

    // close the file
    fclose(fp);
//    void *realFoo = dlsym(RTLD_NEXT, "__ubsan_get_current_report_data");
//    abort();
//    exit(1);
//
//    realFoo("");
//
//
    orig___ubsan_get_current_report_data(OutIssueKind, OutMessage, OutFilename, OutLine, OutCol, OutMemoryAddr);
//    void (*realFoo)(const char **OutIssueKind,
//                    const char **OutMessage,
//                    const char **OutFilename, unsigned *OutLine,
//                    unsigned *OutCol, char **OutMemoryAddr) = (const char **OutIssueKind,
//                                                                const char **OutMessage,
//                                                                const char **OutFilename, unsigned *OutLine,
//                                                                unsigned *OutCol, char **OutMemoryAddr) dlsym(RTLD_NEXT, "__ubsan_get_current_report_data");
//    realFoo(

}

//
////void (*orig__ubsan_get_current_report_data)(const char **OutIssueKind,
////                                             const char **OutMessage,
////                                             const char **OutFilename, unsigned *OutLine,
////                                             unsigned *OutCol, char **OutMemoryAddr);
//
//__attribute__((visibility("default")))
//extern "C"
//void __ubsan_get_current_report_data(const char **OutIssueKind,
//                                const char **OutMessage,
//                                const char **OutFilename, unsigned *OutLine,
//                                unsigned *OutCol, char **OutMemoryAddr) {
//    printf("in my reporter\n");
////
//    FILE *fp = fopen("/tmp/reporter.txt", "w");
//    if (fp == NULL)
//    {
////        printf("Error opening the file %s", filename);
////        return -1;
//        return;
//    }
//    // write to the text file
//    for (int i = 0; i < 10; i++)
//        fprintf(fp, "This is the line #%d\n", i + 1);
//
//    // close the file
//    fclose(fp);
////    void *realFoo = dlsym(RTLD_NEXT, "__ubsan_get_current_report_data");
////    abort();
//    exit(1);
////
////    realFoo("");
////
////
////    void (*realFoo)(const char **OutIssueKind,
////                    const char **OutMessage,
////                    const char **OutFilename, unsigned *OutLine,
////                    unsigned *OutCol, char **OutMemoryAddr) = (const char **OutIssueKind,
////                                                                const char **OutMessage,
////                                                                const char **OutFilename, unsigned *OutLine,
////                                                                unsigned *OutCol, char **OutMemoryAddr) dlsym(RTLD_NEXT, "__ubsan_get_current_report_data");
////    realFoo(
//
//}

//extern "C" void __ubsan_on_report(void);


//extern "C"
//void __ubsan_on_report(void) {
//    printf("my report 2\n");
//}
//
//
//extern "C"
//void my__ubsan_on_report(void) {
//    printf("my report\n");
////    orig___ubsan_on_report();
//    __ubsan_on_report();
//}
//
//
//
////DYLD_INTERPOSE(__ubsan_get_current_report_data, my__ubsan_get_current_report_data)
//////
//////
//__attribute__((constructor)) void _swizzle(void) {
//    rebind_symbols((struct rebinding[2]){
//        {"__ubsan_on_report", (void *)my__ubsan_on_report, (void * *)&orig___ubsan_on_report},
////        {"__ubsan_get_current_report_data", (void *)my___ubsan_get_current_report_data, (void * *)&orig___ubsan_get_current_report_data}
//    }, 1);
////    rebind_symbols((struct rebinding[2]){{"__ubsan_get_current_report_data", (void *)my___ubsan_get_current_report_data, (void * *)&orig___ubsan_get_current_report_data}}, 1);
//}

////    int ret = rebind_symbols((struct rebinding[2]){{"__ubsan_get_current_report_data", my__ubsan_get_current_report_data, (void *)&orig__ubsan_get_current_report_data}}, 1);
//
//
//    if (dyld_dynamic_interpose == NULL) {
//        printf("unable to resolve dyld_dynamic_interpose");
//        exit(1);
//    }
//
//    printf("getting handle to main thread\n");
//    void *main_thread = dlopen(NULL, RTLD_NOW);
//
//    const void* symbol = dlsym(main_thread, "main");
//    if (!symbol) {
//        printf("unable to resolve symbol for main thread\n");
//    }
//    Dl_info info = {};
//    if (!dladdr(symbol, &info)) {
//        printf("unable to find mach header\n");
//    }
//
//    void *ubsanlib = dlopen("/Applications/Xcode-14.1.0-RC2.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/14.0.0/lib/darwin/libclang_rt.ubsan_osx_dynamic.dylib", RTLD_NOW);
//
//    const void* symbol2 = dlsym(ubsanlib, "__ZN11__sanitizer15StripPathPrefixEPKcS1_");
//    if (!symbol2) {
//        printf("cannot find c++ thing\n");
//    }
//
//    const void* symbol3 = dlsym(ubsanlib, "_ZN11__sanitizer15StripPathPrefixEPKcS1_");
//    if (!symbol3) {
//        printf("cannot find c++ thing 2\n");
//    }
//
//    const void* symbol4 = dlsym(RTLD_NEXT, "__sanitizer::StripPathPrefix");
//    if (!symbol4) {
//        printf("cannot find c++ thing 3\n");
//    }
//
//
////    struct dyld_interpose_tuple sTable[] = { {&__sanitizer::myStripPathPrefix, &symbol2} };
////
////
////
////
////    const struct mach_header *header = (struct mach_header *)info.dli_fbase;
////
////    printf("doing it!\n");
////    dyld_dynamic_interpose(header, sTable, 1);
//
////    printf("ret: %d\n", ret);
////    __ubsan_get_current_report_data(NULL, NULL,NULL,NULL,NULL,NULL);
////     rebind_symbols((struct rebinding[2]){{"__sanitizer_report_error_summary", my__sanitizer_report_error_summary, (void *)&orig___sanitizer_report_error_summary}}, 1);
//
//}

class SourceLocation {
    const char *Filename;
    int Line;
    int Column;
};

class TypeDescriptor {
    /// A value from the \c Kind enumeration, specifying what flavor of type we
    /// have.
    int TypeKind;

    /// A \c Type-specific value providing information which allows us to
    /// interpret the meaning of a ValueHandle of this type.
    int TypeInfo;

    /// The name of the type follows, in a format suitable for including in
    /// diagnostics.
    char TypeName[1];
};


struct OverflowData {
  SourceLocation Loc;
  const TypeDescriptor &Type;
};


void foo() {
    int x = INT_MAX;
    //        OverflowData a = {.Loc = SourceLocation {}, .Type = TypeDescriptor {}};
    x += 1; // Integer overflow here
    printf("x = %i\n", x);
}



int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        printf("strip working? %s\n", __sanitizer::StripPathPrefix("/foo/bar.txt", "/foo"));
        foo();
    }
    return 0;
}
