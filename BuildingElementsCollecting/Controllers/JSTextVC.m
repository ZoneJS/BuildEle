//
//  JSTextVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/3/25.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSTextVC.h"

#import "JSTextAttributeExampleVC.h"
#import "JSAsyncTextVC.h"

@interface JSTextVC ()
    
@end

@implementation JSTextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArr = @[@"text Attributes 1",
                   @"async text"];
    self.ctrlsArr = @[@"JSTextAttributeExampleVC",
                  @"JSAsyncTextVC"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
