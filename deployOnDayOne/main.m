//
//  main.m
//  deployOnDayOne
//
//  Created by Zachary Drossman on 1/28/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyApp.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MyApp *newApp = [[MyApp alloc] init];
        
        [newApp execute];
    }
    return 0;
}

