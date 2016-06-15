//
//  JSLoginViewModel.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/15.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSLoginViewModel.h"
#import "MBProgressHUD.h"

@implementation JSLoginViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    //设置按钮可否点击
    _loginEnableSignal = [RACSignal combineLatest:@[RACObserve(self, account), RACObserve(self, pwd)] reduce:^id(NSString *account, NSString *password){
        return @(account.length > 0 && password.length > 0);
    }];
    
    //    登陆命令
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"发送登陆请求获取请求结果？");
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"这是请求登陆的数据?"];
                //                请求完数据不论成功或失败再sendcompleted
                [subscriber sendCompleted];
            });
            return nil;
        }];
    }];
    
    //3.
    [self.loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        //        获取登陆结果判断是否成功决定是否跳转下个页面
        NSLog(@"这是登陆的结果: %@", x);
    }];
    
    [self.loginCommand.executing subscribeNext:^(id x) {
        //        获取登陆状态来判断弹什么样的提示框
        if ([x boolValue] == YES) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.labelText = @"login...";
            hud.dimBackground = YES;
        } else {
            NSLog(@"登陆完成");
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            
        }
    }];

}

@end
