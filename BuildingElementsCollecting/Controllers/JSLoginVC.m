//
//  JSLoginVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/3/23.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSLoginVC.h"

#import "JSSideVC.h"

#import "MMDrawerController.h"
#import "Masonry.h"

@interface JSLoginVC ()

@end

@implementation JSLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton new];
    [btn setTitle:@"登陆" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

- (void)loginAction {
    UIViewController *VC = [[UIViewController alloc] init];
    VC.view.backgroundColor = [UIColor greenColor];
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:VC];
    MMDrawerController *rootVC = [[MMDrawerController alloc] initWithCenterViewController:navCtrl leftDrawerViewController:[[JSSideVC alloc] init]];
    [UIApplication sharedApplication].delegate.window.rootViewController = rootVC;
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
