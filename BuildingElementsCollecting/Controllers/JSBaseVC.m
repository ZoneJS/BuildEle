//
//  JSBaseVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/3/23.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSBaseVC.h"

@interface JSBaseVC ()

@end

@implementation JSBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];//navigationBar的颜色
    self.navigationController.navigationBar.tintColor =
        [UIColor whiteColor];//返回按钮的颜色
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    // Do any additional setup after loading the view.
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
