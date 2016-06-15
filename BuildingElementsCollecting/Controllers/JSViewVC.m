//
//  JSViewVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/5/15.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSViewVC.h"

@interface JSViewVC () {
    UIView *_back;
    CALayer *_testL;
    UIImageView *_imgV;
}

@end



@implementation JSViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArr = @[@"masktobounds对layer的影响",
                       @"复合变换",
                       @"3d变换",
                       @"sublayerTransformTest",
                       @"radiusTest",
                       @"CATextLayerTest",
                       @"d3Test",
                       @"jsCAGradientLayerTest渐变色吧",
                       @"repeatingLayersTest重复",
                       @"mirroringTest",
                       @"transactionBlockTest",
                       @"changeColor关键帧动画",
                       @"bezierPathAnimationTest贝塞尔曲线动画",
                       @"rotateTest旋转动画",
                       @"switchImgCATransitionTest过渡",
                       @"performTransitionTest",
                       @"手动管理动画",
                       @"开关门动画",
                       @"手势动画",
                       @"镂空图像hollowView"];
    
    self.selectorsArr = @[@"compareMaskBounds",
                          @"compositeTransform",
                          @"d3transform",
                          @"sublayerTransformTest",
                          @"radiusTest",
                          @"CATextLayerTest",
                          @"d3Test",
                          @"jsCAGradientLayerTest",
                          @"repeatingLayersTest",
                          @"mirroringTest",
                          @"transactionBlockTest",
                          @"changeColor",
                          @"bezierPathAnimationTest",
                          @"rotateTest",
                          @"switchImgCATransitionTest",
                          @"performTransitionTest",
                          @"handAct",
                          @"doorAct",
                          @"doorActWithPanGesture",
                          @"hollowView"];
    // Do any additional setup after loading the view.
}

- (void)addBack {
    UIView *back = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    back.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
    [[UIApplication sharedApplication].keyWindow addSubview:back];
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAct)];
    [back addGestureRecognizer:g];
    _back = back;
}

- (void)compareMaskBounds {
    [self addBack];
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2, 100, 200, 200)];
    v1.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:.4];
    UIView *add1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    add1.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.5];
//    add1.center = CGPointMake((kScreenWidth - 200) / 2, 100);
    add1.center = CGPointMake(0, 0);
    [_back addSubview:v1];
    [v1 addSubview:add1];
    v1.layer.cornerRadius = 20.f;
    v1.layer.masksToBounds = YES;
}

//若干方法创建一个复合变换
- (void)compositeTransform {
    CGAffineTransform t = CGAffineTransformIdentity;
    t = CGAffineTransformScale(t, .5, .5);
    t = CGAffineTransformRotate(t, M_PI / 180.0 * 30);
//    t = CGAffineTransformTranslate(t, 200, 0);
    self.view.layer.affineTransform = t;
    
}

//透视效果 3d
- (void)d3transform {
    CATransform3D t = CATransform3DIdentity;
    //m34的默认值是0，我们可以通过设置m34为-1.0 / d来应用透视效果，d代表了想象中视角相机和屏幕之间的距离，以像素为单位，大概估算一个就好了。因为视角相机实际上并不存在，所以可以根据屏幕上的显示效果自由决定它的放置的位置。通常500-1000就已经很好了，但对于特定的图层有时候更小或者更大的值会看起来更舒服，减少距离的值会增强透视效果，所以一个非常微小的值会让它看起来更加失真，然而一个非常大的值会让它基本失去透视效果
    t.m34 = - 1.0 / 500.0;
    t = CATransform3DRotate(t, M_PI_4, 0, 1, 0);
    //绕y轴转45度
    self.view.layer.transform = t;
    
}

- (void)sublayerTransformTest {
    [self addBack];
    CATransform3D t = CATransform3DIdentity;
    t.m34 = -1.0 / 500.0;
    _back.layer.sublayerTransform = t;

    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(10, 150, 100, 100)];
    v1.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.3];
    [_back addSubview:v1];
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 110, 150, 100, 100)];
    v2.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.3];
    [_back addSubview:v2];
    
    CATransform3D t1 = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    CATransform3D t2 = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);
    v1.layer.transform = t1;
    v2.layer.transform = t2;
    
}

//圆角
- (void)radiusTest {
    [self addBack];
    CGRect rect = CGRectMake(50, 50, 100, 100);
    CGSize radii = CGSizeMake(20, 20);
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [[UIColor greenColor] colorWithAlphaComponent:.4].CGColor;
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = 3;
    shapeLayer.lineCap = kCALineCapRound;
    [_back.layer addSublayer:shapeLayer];
    
}

//catextlayer

- (void)CATextLayerTest {
    [self addBack];
    UIView *textV = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 150, 200)];
    [_back addSubview:textV];
    
    CATextLayer *l = [CATextLayer layer];
    l.frame = textV.frame;
    [textV.layer addSublayer:l];
    
    l.foregroundColor = [[UIColor blueColor] colorWithAlphaComponent:.8].CGColor;
    l.alignmentMode = kCAAlignmentJustified;
    l.wrapped = YES;
    
    UIFont *font = [UIFont systemFontOfSize:15];
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    l.font = fontRef;
    l.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    l.contentsScale = [UIScreen mainScreen].scale;
    //以Retina的方式渲染，用来决定图层内容应该以怎样的分辨率来渲染。contentsScale并不关心屏幕的拉伸因素而总是默认为1.0。如果我们想以Retina的质量来显示文字，我们就得手动地设置CATextLayer的contentsScale属性
    
    //choose some text
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing 🐒elit. !uisque massa arcu, eleifend vel";
    l.string = text;
}

//用CATransformLayer装配一个3D图层体系
- (CALayer *)faceWithTransform:(CATransform3D)transform {
    //create cube face layer
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(-50, -50, 100, 100);
    
    //apply a random color
    CGFloat red = (rand() / (double)INT_MAX);
    CGFloat green = (rand() / (double)INT_MAX);
    CGFloat blue = (rand() / (double)INT_MAX);
    NSLog(@"%f, %f, %f",red, green, blue);
    face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    //appl
    face.transform = transform;
    return face;
}

#pragma mark - 3d测试

- (CALayer *)cubeWithTransform:(CATransform3D)transform {
    CATransformLayer *cube = [CATransformLayer layer];
    
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //add cube face 2
    ct = CATransform3DMakeTranslation(50, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(0, -50, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //4
    ct = CATransform3DMakeTranslation(0, 50, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(-50, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(0, 0, -50);
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    CGSize containerSize = self.view.bounds.size;
    cube.position = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
    
    cube.transform = transform;
    return cube;
}
- (void)d3Test {
    [self addBack];
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0 / 500.0;
    _back.layer.sublayerTransform = pt;
    
    CATransform3D c1t = CATransform3DIdentity;
    c1t = CATransform3DTranslate(c1t, -100, 0, 0);
    CALayer *cube1 = [self cubeWithTransform:c1t];
    [_back.layer addSublayer:cube1];
    
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 100, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
    CALayer *cube2 = [self cubeWithTransform:c2t];
    [_back.layer addSublayer:cube2];
}

- (void)tapAct {
    [_back removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - jsCAGradientLayerTest

- (void)jsCAGradientLayerTest {
    [self addBack];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(10, 100, 140, 140);
    [_back.layer addSublayer:gradientLayer];
    
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor blueColor].CGColor, (__bridge id)[UIColor greenColor].CGColor];
    
//    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
}

#pragma mark - 重复图层（Repeating Layers）

- (void)repeatingLayersTest {
    [self addBack];
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = CGRectMake(10, 100, 100, 100);
    [_back.layer addSublayer:replicator];
    
    replicator.instanceCount = 6;
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 200, 0);
    transform = CATransform3DRotate(transform, M_PI / 5.0, 0, 0, 1);
    transform = CATransform3DTranslate(transform, 0, -200, 0);
    replicator.instanceTransform = transform;
    
    replicator.instanceBlueOffset = -0.1;
    replicator.instanceRedOffset = -0.1;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 100.0f, 100.0f);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [replicator addSublayer:layer];
}

#pragma mark - 镜像 

- (void)mirroringTest {
    [self addBack];
    
    CAReplicatorLayer *layer = [CAReplicatorLayer layer];
    layer.frame = CGRectMake(100, 150, 100, 100);
    //无效！看来镜像的是子图层
    layer.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:.3].CGColor;
    layer.instanceCount = 2;
    [_back.layer addSublayer:layer];
    CALayer *l = [CALayer layer];
    l.frame = CGRectMake(0, 0, 100, 100);
    l.contents = (__bridge id)[UIImage imageNamed:@"pia"].CGImage;
    [layer addSublayer:l];
    
    CATransform3D transform = CATransform3DIdentity;
    CGFloat verticalOffset = layer.bounds.size.height + 2;
    transform = CATransform3DTranslate(transform, 0, verticalOffset, 0);
    transform = CATransform3DScale(transform, 1, -1, 0);
    layer.instanceTransform = transform;
    
    layer.instanceAlphaOffset = -0.5;
    
}

#pragma mark - 完成块

- (void)transactionBlockTest {
    [self addBack];
    
    CALayer *l = [CALayer layer];
    l.frame = CGRectMake(50, 100, 150, 150);
    l.backgroundColor = [UIColor redColor].CGColor;
    [_back.layer addSublayer:l];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:14.0];
    [CATransaction setCompletionBlock:^{
        CGAffineTransform transform = l.affineTransform;
        transform = CGAffineTransformRotate(transform, M_PI_2);
        l.affineTransform = transform;
    }];
    
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    l.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    [CATransaction commit];
}

#pragma mark - 动画
//关键帧
- (void)changeColor {
    [self addBack];
    
    CALayer *l = [CALayer layer];
    l.frame = CGRectMake(50, 100, 150, 150);
    [_back.layer addSublayer:l];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.duration = 2.0;
    animation.repeatCount = 10;
    animation.keyPath = @"backgroundColor";
    animation.values = @[(__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor orangeColor].CGColor];
    [l addAnimation:animation forKey:nil];
    
}

//贝塞尔曲线

- (void)bezierPathAnimationTest {
    [self addBack];
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(50, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(140, 77) controlPoint2:CGPointMake(220, 220)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [_back.layer addSublayer:pathLayer];
    
    CALayer *ship = [CALayer layer];
    ship.frame = CGRectMake(0, 0, 64, 64);
    ship.position = CGPointMake(50, 150);
    ship.contents = (__bridge id)[UIImage imageNamed:@"pia"].CGImage;
//    ship.backgroundColor = [UIColor blueColor].CGColor;
    [_back.layer addSublayer:ship];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.duration = 5.0f;
    animation.path = bezierPath.CGPath;
    animation.keyPath = @"position";//???:这个需要记忆的？
    animation.rotationMode = kCAAnimationRotateAuto;//!!!: 运动沿着贝塞尔切线
    [ship addAnimation:animation forKey:nil];
    
}

//跳跃旋转我闭着眼

- (void)rotateTest {
    [self addBack];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 80, 80);
    layer.position = CGPointMake(10, 110);
    layer.contents = (__bridge id)[UIImage imageNamed:@"pia"].CGImage;
    [_back.layer addSublayer:layer];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 3.;
    animation.byValue = @(M_PI * 2);
    [layer addAnimation:animation forKey:nil];
}

//过渡动画

- (void)switchImgCATransitionTest {
    [self addBack];
    static int index = 0;
//    NSArray *arr = @[[UIImage imageNamed:@"pia"],
//                     [UIImage imageNamed:@"cube"],
//                     [UIImage imageNamed:@"mew_baseline"],
//                     [UIImage imageNamed:@"Weibo@3x"]];
    
    UIImageView *l = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    l.image = [UIImage imageNamed:@"pia"];
    [_back addSubview:l];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 5.0;
    [l.layer addAnimation:transition forKey:nil];
    l.image = [UIImage imageNamed:@"cube"];
}

//自定义过渡效果

- (void)performTransitionTest {
    [self addBack];
    
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES, 0.0);
    [_back.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *coverImg = UIGraphicsGetImageFromCurrentImageContext();
    //insert snapshot view in front of this one
    UIView *coverView = [[UIImageView alloc] initWithImage:coverImg];
    coverView.frame = _back.bounds;
    [_back addSubview:coverView];
    //update the view (we';; simpl rendomize the layer background color)
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    _back.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //perform animation (anything you like)
    [UIView animateWithDuration:1.0 animations:^{
        CGAffineTransform transfrom = CGAffineTransformMakeScale(0.01, 0.01);
        transfrom = CGAffineTransformRotate(transfrom, M_PI);
        coverView.transform = transfrom;
        coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [coverView removeFromSuperview];
    }];
}

//手工管理动画
- (void)handAct {
    [self addBack];
    
    NSArray *titles = @[@"开始",
                        @"停止"];
    NSArray *selectors = @[@"start",
                           @"stop"];
    for (int i = 0 ; i < 2 ; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100 + 50 * i, 110, 40, 30)];
        btn.backgroundColor = [UIColor redColor];
        [_back addSubview:btn];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
//        NSString *selectorStr = selectors
        [btn addTarget:self action:NSSelectorFromString(selectors[i]) forControlEvents:UIControlEventTouchUpInside];
    }
    CALayer *ship = [CALayer layer];
    _testL = ship;
    ship.frame = CGRectMake(100, 110, 50, 50);
    ship.contents = (__bridge id)[UIImage imageNamed:@"pia"].CGImage;
    [_back.layer addSublayer:ship];
    
}
- (void)start {
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 3.0;
    animation.byValue = @(M_PI * 2);
    animation.delegate = self;
    [_testL addAnimation:animation forKey:@"rotateAnimation"];
}
- (void)stop {
    [_testL removeAnimationForKey:@"rotateAnimation"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"The animation stopped (finished: %@)", flag? @"YES": @"NO");
}

//开关门动画
- (void)doorAct {
    [self addBack];
    CALayer *door = [CALayer layer];
    door.frame = CGRectMake(50, 100, 100, 200);
    door.anchorPoint = CGPointMake(0, 0.5);
    door.position = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
//    door.contents = (__bridge id)[UIImage imageNamed:@"pia"].CGImage;
    door.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:.5].CGColor;
    [_back.layer addSublayer:door];
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    _back.layer.sublayerTransform = perspective;
    //apply swinging animation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2 * 3 / 4);
    animation.duration = 2.0;
    animation.repeatDuration = INFINITY;
    animation.autoreverses = YES;
    [door addAnimation:animation forKey:nil];
    
}

//相对时间测试
- (void)bezierPathAnimationTimeTest {
    [self addBack];
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(50, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(140, 77) controlPoint2:CGPointMake(220, 220)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [_back.layer addSublayer:pathLayer];
    
    CALayer *ship = [CALayer layer];
    ship.frame = CGRectMake(0, 0, 64, 64);
    ship.position = CGPointMake(50, 150);
    ship.contents = (__bridge id)[UIImage imageNamed:@"pia"].CGImage;
    //    ship.backgroundColor = [UIColor blueColor].CGColor;
    [_back.layer addSublayer:ship];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.duration = 7.0f;
    animation.beginTime = 2.0f;//相当于动画的延时
    //timeOffset和beginTime类似，但是和增加beginTime导致的延迟动画不同，增加timeOffset只是让动画快进到某一点，例如，对于一个持续1秒的动画来说，设置timeOffset为0.5意味着动画将从一半的地方开始。
    animation.path = bezierPath.CGPath;
    animation.keyPath = @"position";//???:这个需要记忆的？
    animation.rotationMode = kCAAnimationRotateAuto;//!!!: 运动沿着贝塞尔切线
    [ship addAnimation:animation forKey:nil];
    
}

//手势控制动画

- (void)doorActWithPanGesture {
    [self addBack];
    CALayer *door = [CALayer layer];
    door.frame = CGRectMake(50, 100, 100, 200);
    door.anchorPoint = CGPointMake(0, 0.5);
    door.position = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    _testL = door;
    //    door.contents = (__bridge id)[UIImage imageNamed:@"pia"].CGImage;
    door.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:.5].CGColor;
    [_back.layer addSublayer:door];
    UIPanGestureRecognizer *g = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_back addGestureRecognizer:g];
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    _back.layer.sublayerTransform = perspective;
    //apply swinging animation
}
- (void)pan:(UIPanGestureRecognizer *)pan {
    CGFloat x = [pan translationInView:_back].x;
    x /= 200.f;
    
    CATransform3D t = CATransform3DIdentity;
    t = CATransform3DRotate(t, x * M_PI_2, 0, 1, 0);
    _testL.transform = t;
}

//镂空
- (void)hollowView {
//    UIGraphicsBeginImageContext(CGSizeMake(150, 150));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, kScreenHeight), NO, 1.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetRGBFillColor(ctx, 0,1,1,0.5);
    CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] colorWithAlphaComponent:.6].CGColor);
    CGContextFillRect(ctx, [UIScreen mainScreen].bounds);
    
//    CGContextClearRect(ctx, CGRectMake(50, 100, 50, 50));
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextAddEllipseInRect(ctx, CGRectMake(50, 250, 50, 50));
    CGContextAddRect(ctx, CGRectMake(110, 100, 50, 50));
//    CGContextStrokeEllipseInRect(ctx, CGRectMake(50, 200, 50, 50));
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    CGContextFillPath(ctx);
    
    UIImage* returnimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imgV.image = returnimage;
    imgV.layer.contents = (__bridge id)returnimage.CGImage;
    
    //TODO: 研究怎么使用mask实现镂空效果
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
//    CAShapeLayer *l = [CAShapeLayer layer];
//    l.path = path.CGPath;
//    l.fillColor = [UIColor clearColor].CGColor;
//    l.lineDashPattern = @[@2, @2];
//    l.strokeColor = [UIColor blackColor].CGColor;
//    imgV.layer.mask = l;
//    imgV.layer.masksToBounds = YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:imgV];
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgtapAct)];
    [imgV addGestureRecognizer:g];
    _imgV = imgV;
    imgV.userInteractionEnabled = YES;
}
- (void)imgtapAct {
    [_imgV removeFromSuperview];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will oy the transform and return
ften want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
