//
//  JSTestRacSignal2ndVC.h
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/13.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSBaseVC.h"
#import "ReactiveCocoa.h"

@interface JSTestRacSignal2ndVC : JSBaseVC

@property (nonatomic, strong) RACSubject *delegateSignal;

@end
