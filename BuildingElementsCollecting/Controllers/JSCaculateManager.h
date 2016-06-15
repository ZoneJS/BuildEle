//
//  JSAddManager.h
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/5/25.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JSCaculateManager : NSObject

typedef JSCaculateManager *(^addBlock)(long);

@property (nonatomic, assign) long result;

- (int)x;
- (JSCaculateManager *(^)(long))add;

- (addBlock)add1;

+ (JSCaculateManager *)manager;
@end
