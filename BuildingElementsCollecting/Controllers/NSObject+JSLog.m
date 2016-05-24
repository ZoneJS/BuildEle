//
//  NSObject+JSLog.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/5/23.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "NSObject+JSLog.h"

@implementation NSObject (JSLog)

+ (void)resolveDict:(NSDictionary *)dict {
    //拼接属性字符串代码
    NSMutableString *strM = [NSMutableString string];
    
    //便利字典，把字典所有的key取出来，生成对应的属性代码
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //类型经常变，抽出来
        NSString *type;
        
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]) {
            type = @"NSString";
        } else if ([obj isKindOfClass:[NSArray class]]) {
            type = @"NSArray";
        } else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]) {
            type = @"int";
        } else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]) {
            type = @"NSDictionary";
        }
        
        //属性字符串
        NSString *str;
        if ([type containsString:@"NS"]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;",type, key];
        } else {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) %@ %@;", type, key];
        }
        
        //生成属性字符串就自动换行
        [strM appendFormat:@"\n%@\n", str];
    }];
    
    //把拼接好的字符串打印出来
    NSLog(@"%@", strM);
}

@end
