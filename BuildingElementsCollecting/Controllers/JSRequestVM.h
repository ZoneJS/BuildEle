//
//  JSRequestVM.h
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/15.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"

@interface JSRequestVM : NSObject

@property (nonatomic, strong, readonly) RACCommand *requestCommand;

@end
