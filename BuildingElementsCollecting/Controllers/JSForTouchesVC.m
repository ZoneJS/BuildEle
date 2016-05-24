//
//  JSForTouchesVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/5/19.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSForTouchesVC.h"

@interface JSForTouchesVC () {
    CALayer *_testL;
}

@end

@implementation JSForTouchesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self simpleTest];
    // Do any additional setup after loading the view.
}

- (void)simpleTest {
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 100, 100);
    layer.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:.5].CGColor;
    [self.view.layer addSublayer:layer];
    _testL = layer;
}

//???: 在普通view上无效的
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:1.0];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//    _testL.position = [[touches anyObject] locationInView:self.view];
//    [CATransaction commit];
//}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    _testL.position = [[touches anyObject] locationInView:self.view];
    [CATransaction commit];
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
