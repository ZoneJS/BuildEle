//
//  JSTestRacSignal2ndVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/13.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSTestRacSignal2ndVC.h"

@implementation JSTestRacSignal2ndVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.delegateSignal) {
        [self.delegateSignal sendNext:@"这里跳转到了第二个控制器哦"];
    }
}

@end
