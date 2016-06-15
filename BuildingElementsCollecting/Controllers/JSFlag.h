//
//  JSFlag.h
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/13.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSFlag : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;

+ (instancetype)flagWithDict:(NSDictionary *)dict;

@end
