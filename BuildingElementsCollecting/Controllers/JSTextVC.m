//
//  JSTextVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/3/25.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSTextVC.h"

#import "JSTextAttributeExampleVC.h"
#import "JSAsyncTextVC.h"

@interface JSTextVC () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *_mainView;
    NSArray *_titlesArr;
    NSArray *_ctrlsArr;
}

@end

@implementation JSTextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titlesArr = @[@"text Attributes 1",
                   @"async text"];
    _ctrlsArr = @[@"JSTextAttributeExampleVC",
                  @"JSAsyncTextVC"];
    
    _mainView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:_mainView];
    _mainView.delegate = self;
    _mainView.dataSource = self;//!!!: 5m datasource和delegate成对出现
    
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JS"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JS"];
        cell.textLabel.text = _titlesArr[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class cls = NSClassFromString(_ctrlsArr[indexPath.row]);
    if (cls) {
        [self.navigationController pushViewController:[[cls alloc] init] animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
