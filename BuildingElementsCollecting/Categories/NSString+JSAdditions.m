//
//  NSString+JSAdditions.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/4/10.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "NSString+JSAdditions.h"

@implementation NSString (JSAdditions)

- (NSString *)js_myLowercaseString {
    NSString *lowercase = [self js_myLowercaseString];
    NSLog(@"%@ => %@", self, lowercase);
    return lowercase;
}

@end
