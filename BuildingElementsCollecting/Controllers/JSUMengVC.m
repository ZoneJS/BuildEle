//
//  JSUMengVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/5/10.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSUMengVC.h"

@interface JSUMengVC () {
    UITableView *_mainView;
}

@end

@implementation JSUMengVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArr = @[@"share"];
    self.ctrlsArr = @[@"JSUMengShanreTestVC"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
