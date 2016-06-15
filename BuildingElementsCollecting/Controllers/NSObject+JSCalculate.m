//
//  NSObject+JSCalculate.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/2.
//  Copyright © 2016年 zjs. All rights reserved.
//  自己分装的以链式编程思想为基础的通过.

#import "NSObject+JSCalculate.h"

@implementation NSObject (JSCalculate)

+ (long)js_addCalulate:(void (^)(JSCaculateManager *mgr))block {
    JSCaculateManager *manager = [JSCaculateManager manager];
//    JSCaculateManager *manager = [[JSCaculateManager alloc] init];
    
    block(manager);
    
    return manager.result;
}

@end
