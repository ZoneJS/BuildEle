//
//  JSRACLoginVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/15.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSRACLoginVC.h"
#import "ReactiveCocoa.h"
#import "MBProgressHUD.h"
#import "JSLoginViewModel.h"
#import "JSRequestVM.h"
#import "UIImageView+WebCache.h"

@interface JSRACLoginVC () {
    UITextField *_accountF;
    UITextField *_passwordF;
    UIButton *_loginBtn;
    JSLoginViewModel *_loginVM;
    JSRequestVM *_requestVM;
    UIImageView *_imgV;
}

@end

@implementation JSRACLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    mvvm中 vm：视图模型处理界面上的所有业务逻辑其中最好不要包括视图v
    _accountF = [[UITextField alloc] initWithFrame:CGRectMake(30, 80, 200, 40)];
    _passwordF = [[UITextField alloc] initWithFrame:CGRectMake(30, 150, 200, 40)];
    _accountF.backgroundColor = [UIColor grayColor];
    _passwordF.backgroundColor = [UIColor greenColor];
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 220, 200, 40)];
    _loginBtn.backgroundColor = [UIColor blueColor];
    _loginBtn.enabled = NO;
    [_loginBtn setTitle:@"login" forState:UIControlStateNormal];
    _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 300, 80, 80)];
    [self.view addSubview:_imgV];
    [self.view addSubview:_loginBtn];
    [self.view addSubview:_accountF];
    [self.view addSubview:_passwordF];
    
    //    mvvm
    _loginVM = [[JSLoginViewModel alloc] init];
    [self bindVM];
    [self loginEvent];
    
    _requestVM = [[JSRequestVM alloc] init];
    [[_requestVM.requestCommand execute:nil] subscribeNext:^(id x) {
        if (x == nil) {
            _imgV.backgroundColor = [UIColor redColor];
        } else {
            _imgV.image = x;
        }
    }];
//    [_imgV sd_setImageWithURL:[NSURL URLWithString:@"http://img5.imgtn.bdimg.com/it/u=3425851328,2681317699&fm=21&gp=0.png"]];
//    [_requestVM.requestCommand execute:_imgV];
}

- (void)bindVM {
    RAC(_loginVM, account) = _accountF.rac_textSignal;
    RAC(_loginVM, pwd) = _passwordF.rac_textSignal;
}

- (void)loginEvent {
    RAC(_loginBtn, enabled) = _loginVM.loginEnableSignal;
    
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [_loginVM.loginCommand execute:nil];
    }];
}

//常规操作
- (void)normalSetupView {
    //    //设置按钮可否点击
    //    RACSignal *loginEnableSignal = [RACSignal combineLatest:@[_accountF.rac_textSignal, _passwordF.rac_textSignal] reduce:^id(NSString *account, NSString *password){
    //        return @(account.length > 0 && password.length > 0);
    //    }];
    //    [loginEnableSignal subscribeNext:^(id x) {
    //        _loginBtn.enabled = [x boolValue];
    //    }];
    //    //    RAC(_loginBtn, enabled) = loginEnableSignal;
    //    //    同上的
    //
    ////    登陆命令
    //    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    //        NSLog(@"发送登陆请求获取请求结果？");
    //        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                [subscriber sendNext:@"这是请求登陆的数据?"];
    ////                请求完数据不论成功或失败再sendcompleted
    //                [subscriber sendCompleted];
    //            });
    //            return nil;
    //        }];
    //    }];
    //    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
    ////        获取登陆结果判断是否成功决定是否跳转下个页面
    //        NSLog(@"这是登陆的结果: %@", x);
    //    }];
    //
    //    [command.executing subscribeNext:^(id x) {
    ////        获取登陆状态来判断弹什么样的提示框
    //        if ([x boolValue] == YES) {
    //
    //            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //            hud.labelText = @"login...";
    //            hud.dimBackground = YES;
    //        } else {
    //            NSLog(@"登陆完成");
    //            [MBProgressHUD hideHUDForView:self.view animated:YES];
    //
    //        }
    //    }];
    //
    //    //登陆按钮的点击
    //    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    //        NSLog(@"小心!点击登陆按钮了");
    //        [command execute:nil];
    //    }];

}

@end
