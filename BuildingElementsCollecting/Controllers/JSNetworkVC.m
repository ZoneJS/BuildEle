//
//  JSNetworkVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/4/11.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSNetworkVC.h"
#import "AFNetworkReachabilityManager.h"

@interface JSNetworkVC ()

@end

@implementation JSNetworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

//base
- (void)baseAct {
    NSURL *url = [NSURL URLWithString:@"https://example.com/v1/"];
    [NSURL URLWithString:@"%@" relativeToURL:url];
}

//监听网络状态
- (void)monitorNetworkStatus {
    AFNetworkReachabilityManager *monitor = [AFNetworkReachabilityManager sharedManager];
    
    [monitor setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
    case AFNetworkReachabilityStatusUnknown: {
        NSLog(@"未知网络");
        break;
    }
    case AFNetworkReachabilityStatusNotReachable: {
        NSLog(@"duan wang");
        break;
    }
    case AFNetworkReachabilityStatusReachableViaWWAN: {
        NSLog(@"shou ji wang luo");
        break;
    }
    case AFNetworkReachabilityStatusReachableViaWiFi: {
        NSLog(@"wifi");
        break;
    }
        }
    }];
    
    [monitor startMonitoring];
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
