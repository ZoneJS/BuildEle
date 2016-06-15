//
//  AppDelegate.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/3/22.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "AppDelegate.h"

#import "JSBaseRootVC.h"
#import "JSSideVC.h"
#import "MMDrawerController.h"

#import "UMSocial.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //1.本地推送
    //征求推送许可
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
        [self addLocalNotification];
        UILocalNotification *n = [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        NSLog(@"localnotification.userinfo:%@", n.userInfo);
    } else {
        //请求授权
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    }
    //2.remote
    UIUserNotificationSettings *s = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [UMSocialData setAppKey:@"573174b2e0f55ab28a0006a7"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController *VC = [[JSBaseRootVC alloc] init];
    VC.view.backgroundColor = [UIColor greenColor];
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:VC];
    MMDrawerController *rootVC = [[MMDrawerController alloc] initWithCenterViewController:navCtrl leftDrawerViewController:[[JSSideVC alloc] init]];
    rootVC.maximumLeftDrawerWidth = 200;
    [UIApplication sharedApplication].delegate.window.rootViewController = rootVC;

    [self.window makeKeyAndVisible];
    
    return YES;
}
//点击允许或不允许后执行的代码
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        [self addLocalNotification];
    }
}
//如何获取通知中的用户参数字典
//1.app在前台或后台收到通知进入前台
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}
//2.app关闭状态 就是didfinishlaunchwithoptions

#pragma mark - remote push
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"-----------------------my token is----------------------------\n%@",deviceToken);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"-----------------------get remote push token error is %@---------------\n",error);
}

- (void)addLocalNotification {
    //定义本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置调用时间立即触发
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    //通知属性
    notification.alertBody = @"hello,我是本地通知哦（通知主体）";
    notification.applicationIconBadgeNumber = 1;
    notification.alertAction = @"打开应用（待机界面的滑动动作提示）";
    notification.soundName = UILocalNotificationDefaultSoundName;
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
