//
//  JSAutoDictionary.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/4/9.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSAutoDictionary.h"
#import <objc/runtime.h>

@interface JSAutoDictionary ()
@property (nonatomic, strong) NSMutableDictionary *backingStore;

@end

@implementation JSAutoDictionary

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _backingStore = [NSMutableDictionary new];
    
    return self;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    if ([selectorString hasPrefix:@"set"]) {//设置值时有set前缀
        class_addMethod(self,//向类中动态添加方法
                        sel,
                        (IMP)autoDictionarySetter,//函数指针，指向待添加的方法
                        "v@:@");//带添加方法的类型编码－－开头是方法的返回值类型后续表示接受的各个参数
    } else {
        class_addMethod(self,
                        sel,
                        (IMP)autoDictionaryGetter,
                        "@ @:");
    }
    
    return YES;
}

id autoDictionaryGetter(id self, SEL _cmd) {
    JSAutoDictionary *typedSelf = (JSAutoDictionary *)self;
    NSMutableDictionary *backingStore = typedSelf.backingStore;
    
    NSString *key = NSStringFromSelector(_cmd);
    
    return [backingStore objectForKey:key];
}

void autoDictionarySetter(id self, SEL _cmd, id value) {
    JSAutoDictionary *typedSelf = (JSAutoDictionary *)self;
    NSMutableDictionary *backingStore = typedSelf.backingStore;
    
    NSString *selString = NSStringFromSelector(_cmd);
    NSMutableString *key = [selString mutableCopy];
    
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    
    NSString *lowercaseFirstChar = [[key substringToIndex:1] lowercaseString];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:lowercaseFirstChar];
    
    if (value) {
        [backingStore setObject:value forKey:key];
    } else {
        [backingStore removeObjectForKey:key];
    }
}

@end
