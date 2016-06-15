//
//  JSFlag.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/13.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSFlag.h"

@implementation JSFlag

+ (instancetype)flagWithDict:(NSDictionary *)dict {
    JSFlag *flag = [[self alloc] init];
    [flag setValuesForKeysWithDictionary:dict];
    return flag;
}

@end
