//
//  NSObject+JSKVO.h
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/3.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSKVO)

- (void)js_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

@end
