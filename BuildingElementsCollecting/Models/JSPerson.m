//
//  JSPerson.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/4/10.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSPerson.h"
#import <objc/runtime.h>

@implementation JSPerson

- (NSArray *)allProperties {
    unsigned int count;
    
    objc_objectptr_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArr = [NSMutableArray arrayWithCapacity:count];
    //获取类的所有属性（properties），没属性则count为0，properties为nil
    
    for (NSUInteger i = 0; i < count; i++) {
        //获取属性名称
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        
        //获取属性值
//        id propertyValue = [self valueForKey:propertyName];
        
        
        [propertiesArr addObject:name];
    }
    
    free(properties);
    //它是一个数组指针，是c的语法 不free会造成内存泄漏
    
    return propertiesArr;
}

//huo获取对象的成员变量名称
- (NSArray *)allMemberVariables {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    NSMutableArray *results = [NSMutableArray new];
    for (NSUInteger i = 0; i < count; i++) {
        Ivar variable = ivars[i];
        
        const char *name = ivar_getName(variable);
        NSString *varName = [NSString stringWithUTF8String:name];
        
        [results addObject:varName];
    }
    free(ivars);
    
    return results;
}

@end
