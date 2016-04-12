//
//  JSAutoDictionary.h
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/4/9.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSAutoDictionary : NSObject
@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) id opaqueObject;

@end
