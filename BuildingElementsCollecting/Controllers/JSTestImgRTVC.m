//
//  JSTestImgRTVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/5/15.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSTestImgRTVC.h"
#import "JSParentTController.h"

@interface JSTestImgRTVC ()

@end

@implementation JSTestImgRTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArr = @[@"JSImageVC",
                       @"JSWebImgVC",
                       @"JSViewVC",
                       @"翻译第十节《缓冲》>>>",
                       @"父子控制器"];
    self.ctrlsArr = @[@"JSImageVC",
                       @"JSWebImgVC",
                      @"JSViewVC",
                      @"JSTenStartVC",
                      @"JSParentTController"];
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
