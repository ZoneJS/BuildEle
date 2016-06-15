//
//  JSBasisVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/2.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSBasisVC.h"

@implementation JSBasisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ctrlsArr = @[@"JSBaseKnolowedgeVC",
                      @"JSFRPVC",
                      @"JSRACLoginVC"];
    
    self.titlesArr = @[@"基础",
                       @"FRP--reactiveCocoa实践",
                       @"JSRACLoginVC登陆RAC"];
}

@end
