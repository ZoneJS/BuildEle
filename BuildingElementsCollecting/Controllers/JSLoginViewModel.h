//
//  JSLoginViewModel.h
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/15.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"

@interface JSLoginViewModel : NSObject

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *pwd;

@property (nonatomic, strong, readonly) RACSignal *loginEnableSignal;
@property (nonatomic, strong, readonly) RACCommand *loginCommand;

@end
