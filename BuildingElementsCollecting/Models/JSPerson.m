//
//  JSPerson.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/4/10.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSPerson.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation JSPerson

//交换方法的测试
+ (void)load {
    Method testMethod = class_getClassMethod(self, @selector(testMethod));
    Method swapM = class_getClassMethod(self, @selector(method4swap));
    //替换方法， 即替换函数地址
    method_exchangeImplementations(testMethod, swapM);
}

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

- (void)testMethod {
    NSLog(@"for test");
}
- (void)method4swap {
    NSLog(@"换方法了，dude");
}

+ (void)classTestMethod {
    NSLog(@"class");
}

//动态添加方法
void eat(id self, SEL sel) {
    NSLog(@"%@ %@",self, NSStringFromSelector(sel));
}
//当一个对象调用未实现的方法，会调用这个方法处理， 同时把对应的方法列表传过来
//这里我们可以判断未实现的方法是不是我们要动态添加的方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(eat)) {
        //动态添加eat方法
        
        // 第一个参数：给哪个类添加方法
        // 第二个参数：添加方法的方法编号
        // 第三个参数：添加方法的函数实现（函数地址）
        // 第四个参数：函数的类型，(返回值+参数类型) v:void @:对象->self :表示SEL->_cmd
        class_addMethod(self, @selector(eat), eat, "v@:");
    }
    
    return [super resolveInstanceMethod:sel];
}

@end
