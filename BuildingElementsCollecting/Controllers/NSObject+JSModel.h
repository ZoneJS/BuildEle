//
//  NSObject+JSModel.h
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/5/23.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModelDelegate <NSObject>

@optional
//提供一个协议，只要准备这个协议的类，都可以把数组中的字典转模型

+ (NSDictionary *)arrayContainModelClass;

@end

@interface NSObject (JSModel)

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
