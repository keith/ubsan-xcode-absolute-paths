//
//  main.m
//  ub-paths
//
//  Created by Keith Smiley on 11/30/22.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int x = INT_MAX;
        x += 1; // Integer overflow here
        printf("x = %i\n", x);
    }
    return 0;
}
