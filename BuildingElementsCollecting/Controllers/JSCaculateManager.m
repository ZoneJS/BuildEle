//
//  JSAddManager.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/5/25.
//  Copyright © 2016年 zjs. All rights reserved.
//  用block来代替方法

#import "JSCaculateManager.h"

@implementation JSCaculateManager

- (int)x {
    return 3;
}

- (JSCaculateManager *(^)(long))add {
    return ^(long value) {
        _result += value;
        return self;
    };
}

- (addBlock)add1 {
    //要返回的是一个 addblock 型的 block
    return ^(long n) {
        _result += n;
        return self;
    };
}

+ (instancetype)manager {
    static JSCaculateManager *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSingleton = [[JSCaculateManager alloc] init];
    });
    
    return _sharedSingleton;
}


@end
