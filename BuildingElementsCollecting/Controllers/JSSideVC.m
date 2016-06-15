//
//  JSSideVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/3/23.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSSideVC.h"
#import "MMDrawerController.h"
#import "JSFMDBVC.h"
#import "JSImageVC.h"
#import "JSTextVC.h"
#import "JSRuntimeTestVC.h"

#import "UIViewController+MMDrawerController.h"

@interface JSSideVC () {
    NSArray *ctrlsArr;
}

@end

@implementation JSSideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ctrlsArr = @[@"JSFMDBVC",
                 @"JSTestImgRTVC",
                 @"JSTextVC",
                 @"JSRuntimeTestVC",
                 @"JSUMengVC",
                 @"JSBasisVC"];
    
    //测试
    Class class = NSClassFromString(ctrlsArr[1]);
    UINavigationController *nav = [self vcWrappedWithNav:[[class alloc] init]];
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ctrlsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titlesArr = @[@"fmdb",
                           @"UI",
                           @"text",
                           @"runtime",
                           @"友盟分享",
                           @"基础"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.textLabel.text = titlesArr[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class class = NSClassFromString(ctrlsArr[indexPath.row]);
    UINavigationController *nav = [self vcWrappedWithNav:[[class alloc] init]];
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
}

- (UINavigationController *)vcWrappedWithNav:(UIViewController *)VC {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
    return nav;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
