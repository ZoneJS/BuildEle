//
//  JSTenStartVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/5/19.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSTenStartVC.h"
#import "JSForTouchesVC.h"

@interface JSTenStartVC () {
    UIView *_back;
    CALayer *_testL;
}

@end

@implementation JSTenStartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titlesArr = @[@"动画缓冲简单测试",
                       @"ballGame"];
    
    self.selectorsArr = @[@"simpleTest",
                          @"ballGame"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBack {
    UIView *back = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    back.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
    [[UIApplication sharedApplication].keyWindow addSubview:back];
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAct)];
    [back addGestureRecognizer:g];
    _back = back;
}

- (void)tapAct {
    [_back removeFromSuperview];
}

- (void)simpleTest {
    [self.navigationController pushViewController:[JSForTouchesVC new] animated:YES];
//    [self addBack];
//    
//    CALayer *layer = [CALayer layer];
//    layer.frame = CGRectMake(0, 0, 100, 100);
//    layer.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:.5].CGColor;
//    [_back.layer addSublayer:layer];
//    UIPanGestureRecognizer *g1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    [_back addGestureRecognizer:g1];
//    _testL = layer;
}
- (void)pan:(UIPanGestureRecognizer *)g {
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    _testL.position = [g locationInView:_back];
    [CATransaction commit];
}
//???: 无效
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    _testL.position = [[touches anyObject] locationInView:_back];
    [CATransaction commit];
}

#pragma mark - 橡皮球反弹

- (void)ballGame {
    [self addBack];
    
    CGFloat X = kScreenWidth / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kScreenWidth / 2, 32) radius:40 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    CAShapeLayer *l = [CAShapeLayer layer];
    l.path = path.CGPath;
//    l.strokeColor = [UIColor blueColor].CGColor;
    l.fillColor = [UIColor blueColor].CGColor;
    [_back.layer addSublayer:l];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.delegate = self;
    animation.values = @[
                         [NSValue valueWithCGPoint:CGPointMake(kScreenWidth / 2, 32)],
                         [NSValue valueWithCGPoint:CGPointMake(kScreenWidth / 2, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(kScreenWidth / 2, 140)],
                         [NSValue valueWithCGPoint:CGPointMake(kScreenWidth / 2, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(kScreenWidth / 2, 220)],
                         [NSValue valueWithCGPoint:CGPointMake(kScreenWidth / 2, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(kScreenWidth / 2, 250)],
                         [NSValue valueWithCGPoint:CGPointMake(kScreenWidth / 2, 268)]
                         ];
    animation.timingFunctions = @[
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//    animation.keyTimes = @[@2.0, @2.3, @2.5, @2.7, @2.8, @2.9, @2.95, @1.0];
    animation.keyTimes = @[@0.0, @0.3, @0.5, @0.7, @0.8, @0.9, @0.95, @1.0];
    l.position = CGPointMake(kScreenWidth / 2, 268);
    [l addAnimation:animation forKey:nil];
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
