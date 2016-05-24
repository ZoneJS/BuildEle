//
//  Status.m
//  05-Runtime(字典转模型)
//
//  Created by yz on 15/10/13.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "Status1.h"

@implementation Status1

+ (instancetype)statusWithDict:(NSDictionary *)dict
{
    Status1 *status = [[self alloc] init];
    
    [status setValuesForKeysWithDictionary:dict];//!!!: 这样就把字典转模型了！？
    
    return status;
    
}

// 系统调用这个方法，就会报错，可以把系统的方法覆盖，就能继续使用KVC，字典转模型了。
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
