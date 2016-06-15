//
//  JSKVONotifyingPerson.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/3.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSKVONotifyingPerson.h"

#import <objc/message.h>

extern NSString *const observerKey;

@implementation JSKVONotifyingPerson

- (void)setName:(NSString *)name {
    [super setName:name];
    
    //通知观察者调用observeValueForKeyPath
    //需要把观察者保存到当前对象
    //获取观察者
    id observer = objc_getAssociatedObject(self, observerKey);
    
    [observer observeValueForKeyPath:@"name" ofObject:self change:nil context:nil];
    NSLog(@"😄");
}

@end
