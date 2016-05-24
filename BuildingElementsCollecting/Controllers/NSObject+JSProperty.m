//
//  NSObject+JSProperty.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/5/23.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "NSObject+JSProperty.h"

#import <objc/message.h>

static const char *key = "name";

@implementation NSObject (JSProperty)

//分类添加属性的步骤:
//1.在分类中声明get、set方法，本质不是真的成员属性，而是提供get、set方法，供外界获取
//2.在分类实现get、set方法
//3.set方法实现，把传递的值给对象关联。
//4.get方法实现，把关联的值取出来传出去
- (NSString *)name {
    //根据关联的key,获取关联的值
    return objc_getAssociatedObject(self, key);
}

- (void)setName:(NSString *)name {
   //id object:要添加关联的对象
   //const void *key: 关联的key
   //id value: 关联的value
   //objc_AssociationPolicy: 关联的策略
    objc_setAssociatedObject(self, key, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
