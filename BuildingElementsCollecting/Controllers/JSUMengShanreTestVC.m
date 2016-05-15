//
//  JSUMengShanreTestVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/5/10.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSUMengShanreTestVC.h"

#import "UMSocial.h"

@interface JSUMengShanreTestVC ()
<UITableViewDelegate,
 UITableViewDataSource,
 UIActionSheetDelegate,
 UMSocialUIDelegate> {
    UITableView *_tableV;
    UISwitch *_changeSwitcher;
     NSArray *_imgs;
}

@end

@implementation JSUMengShanreTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    [self.view addSubview:_tableV];
    
    _imgs = @[@"sina",
              @"wechat"];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.imageView.image = [UIImage imageNamed:_imgs[indexPath.row]];
    NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
    UMSocialSnsPlatform *snsPlatform = nil;
    if (indexPath.row == 0) {
        snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    }
    else if (indexPath.row == 1) {
        snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline];
    }
    UMSocialAccountEntity *accountEnitity = [snsAccountDic valueForKey:snsPlatform.platformName];

    UISwitch *oauthSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 10, 40, 20)];
    oauthSwitch.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    oauthSwitch.tag = snsPlatform.shareToType;
    [cell addSubview:oauthSwitch];
    oauthSwitch.center = CGPointMake(_tableV.bounds.size.width - 40, oauthSwitch.center.y);
    [oauthSwitch addTarget:self action:@selector(onSwitchOauth:) forControlEvents:UIControlEventValueChanged];
    
    NSString *showUserName = nil;
    //这里判断是否授权
    if ([UMSocialAccountManager isOauthAndTokenNotExpired:snsPlatform.platformName]) {
        [oauthSwitch setOn:YES];
        //这里获取到每个授权账户的昵称
        showUserName = accountEnitity.userName;
    } else {
        [oauthSwitch setOn:NO animated:YES];
        showUserName = [NSString stringWithFormat:@"尚未授权"];
    }
    
    if ([showUserName isEqualToString:@""]) {
        cell.textLabel.text = @"已授权";
    } else{
        cell.textLabel.text = showUserName;
    }
    NSLog(@"%ld, %d\n", (long)indexPath.row, oauthSwitch.on);
//    cell.imageView.image = [UIImage imageNamed:snsPlatform.smallImageName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)onSwitchOauth:(UISwitch *)switcher
{
    _changeSwitcher = switcher;
    //!!!: 注意用点击后的状态来判断
    if (switcher.isOn == YES) {//原来是NO打开后是yes
//    if (NO) {
        

        
    }
    else {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"解除授权" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *unbindAct = [UIAlertAction actionWithTitle:@"解除授权" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [switcher setOn:NO];
            
            //此处调用授权的方法,你可以把下面的platformName 替换成 UMShareToSina,UMShareToTencent等
            NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:switcher.tag];
            
            [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                //           获取微博用户名、uid、token、第三方的原始用户信息thirdPlatformUserProfile等
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //                NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
                    NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
                }
                //这里可以获取到腾讯微博openid,Qzone的token等
                /*
                 if ([platformName isEqualToString:UMShareToTencent]) {
                 [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToTencent completion:^(UMSocialResponseEntity *respose){
                 NSLog(@"get openid  response is %@",respose);
                 }];
                 }
                 */
                [_tableV reloadData];
            });
        }];
        [alertCtrl addAction:cancelAct];
        [alertCtrl addAction:unbindAct];
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    _tableV.frame = CGRectMake(_tableV.frame.origin.x, _tableV.frame.origin.y, _tableV.frame.size.width, 270);
    [_tableV reloadData];
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
