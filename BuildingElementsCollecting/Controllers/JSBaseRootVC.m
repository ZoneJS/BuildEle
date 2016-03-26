//
//  XWCBaseRootVC.m
//  xwc4merchant
//
//  Created by 张军帅 on 16/3/15.
//  Copyright © 2016年 xwc. All rights reserved.
//

#import "JSBaseRootVC.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@implementation JSBaseRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    MMDrawerBarButtonItem *leftBarButtonItem = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(toggleLeftSide)];
    leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleLeftSide {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
