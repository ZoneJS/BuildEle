//
//  NSObject+JSCalculate.h
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/2.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSCaculateManager.h"

@interface NSObject (JSCalculate)

+ (long)js_addCalulate:(void (^)(JSCaculateManager *mgr))block;

@end
