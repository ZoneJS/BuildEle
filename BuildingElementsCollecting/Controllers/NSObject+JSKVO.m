//
//  NSObject+JSKVO.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/3.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "NSObject+JSKVO.h"

#import <objc/message.h>
#import "JSKVONotifyingPerson.h"

NSString *const observerKey = @"observer";

@implementation NSObject (JSKVO)

// 监听某个对象的属性 谁调用就监听谁
- (void)js_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    
    /*
     //1.自定义子类
     //2.重写setName，在内部恢复父类做法，通知观察者
     //3.通过修改当前对象的isa指针，指向子类，从而调用子类的方法
     */
    
    //把观察者保存到当前对象
    objc_setAssociatedObject(self, (__bridge const void *)(observerKey), observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //修改isa指针
    object_setClass(self, [JSKVONotifyingPerson class]);
}

@end
