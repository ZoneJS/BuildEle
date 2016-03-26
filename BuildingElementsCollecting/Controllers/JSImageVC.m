//
//  JSImageVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/3/24.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSImageVC.h"
#import "YYKit.h"

@interface JSImageVC () <UIGestureRecognizerDelegate>{
    UIScrollView *_scrollView;
}

@end

@implementation JSImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [UIScrollView new];
    _scrollView.frame = self.view.bounds;
    [self.view addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor colorWithWhite:0.82 alpha:1];
    
    UILabel *label = [UILabel new];
    label.text = @"测试标题\n 触摸暂停 挪开继续";
    label.size = CGSizeMake(kScreenWidth, 60);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.top = 20;
    [_scrollView addSubview:label];
    
    NSArray *imgsArr = @[@"niconiconi",
                         @"wall-e",
                         @"pia"];
    NSArray *titlesArr = @[@"gif",
                           @"webP",
                           @"png"];

    for (int i = 0; i < 3; i++) {
        [self addImg:[YYImage imageNamed:imgsArr[i]] size:CGSizeZero text:titlesArr[i]];
    }
    
    NSString *path = [[NSBundle mainBundle].bundlePath stringByAppendingString:@"/EmoticonWeibo.bundle/com.sina.default"];
    NSMutableArray *imgPathArr = @[].mutableCopy;
    NSArray *imgNameArr = @[@"/d_baibai@3x.png",
                            @"/d_chanzui@3x.png",
                            @"/d_chijing@3x.png",
                            @"/d_dahaqi@3x.png",
                            @"/d_haha@2x.png",
                            @"/d_haixiu@3x.png"];
    for (int i = 0; i < 6; i++) {
        [imgPathArr addObject:[path stringByAppendingString:imgNameArr[i]]];
    }
    YYFrameImage *img = [[YYFrameImage alloc] initWithImagePaths:imgPathArr oneFrameDuration:0.3 loopCount:0];
    [self addImg:img size:CGSizeZero text:nil];
    
    [self addSpriteSheetImg];
    // Do any additional setup after loading the view.
}
//从一张图中截取,我还考虑用frameImg，不知道 怎么截
- (void)addSpriteSheetImg {
    NSString *path = [[NSBundle mainBundle].bundlePath stringByAppendingString:@"/ResourceTwitter.bundle/fav02l-sheet@2x.png"];
    //TODO: scale 是什么属性
    UIImage *img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:path] scale:2];
//    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfFile:path] scale:2];
    
    NSMutableArray *contentRects = @[].mutableCopy;
    NSMutableArray *duritions = [NSMutableArray array];
    //切成8 ＊ 12张
    CGSize size = CGSizeMake(img.size.width / 8, img.size.height / 12);
    for (int j = 0; j < 12; j++) {
        for (int i = 0; i < 8; i++) {//这里浪费了10多分钟，图片横着一行一行扫描过去
            CGRect rect;
            rect.size = size;
            rect.origin.x = i * size.width;
            rect.origin.y = j * size.height;
            [contentRects addObject:[NSValue valueWithCGRect:rect]];
            [duritions addObject:@(1 / 60.0)];//
        }
    }
    YYSpriteSheetImage *spriteSheetImg = [[YYSpriteSheetImage alloc] initWithSpriteSheetImage:img
                                                           contentRects:contentRects frameDurations:duritions
                                                              loopCount:0];
    [self addImg:spriteSheetImg size:size text:nil];
}

- (void)addImg:(UIImage *)img size:(CGSize)size text:(NSString *)text {
    YYAnimatedImageView *imgView = [[YYAnimatedImageView alloc] initWithImage:img];
    if (size.height > 0 && size.width > 0) imgView.size = size;
    imgView.centerX = _scrollView.centerX;
    imgView.top = [(UIView *)[_scrollView.subviews lastObject] bottom] + 30;
    [_scrollView addSubview:imgView];//需要后添加
    [self addTapControlToAnimatedImgView:imgView];
    [self addPanGestureToImgView:imgView];//TODO: 不太懂？？

    UILabel *label = [UILabel new];
    label.text = text;
    label.size = CGSizeMake(kScreenWidth, 20);
    [_scrollView addSubview:label];
    label.top = imgView.bottom + 10;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth,  label.bottom + 20);//勿忘
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return YES;
//}

- (void)addTapControlToAnimatedImgView:(YYAnimatedImageView *)imgView {
    imgView.userInteractionEnabled = YES;
    
    @weakify(imgView);//这里浪费了10分钟一开始UITapGestureRecognizer 是UIGestureRecognizer仔细，要拿子类来初始化
    UIGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(imgView);
        if ([imgView isAnimating]) {
            [imgView stopAnimating];
        } else {
            [imgView startAnimating];
        }
        UIViewAnimationOptions op = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState;
        [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
            imgView.layer.transformScale = 0.97;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
                imgView.layer.transformScale = 1.008;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
                    imgView.layer.transformScale = 1;
                } completion:NULL];
            }];
        }];
    }];
    tapG.delegate = self;
    
    [imgView addGestureRecognizer:tapG];
}

- (void)addPanGestureToImgView:(YYAnimatedImageView *)imgView {
    imgView.userInteractionEnabled = YES;
    __block BOOL previousIsPlaying;
    
    @weakify(imgView);
    UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(imgView);
        UIImage<YYAnimatedImage> *img = (id)imgView.image;
        if (![img conformsToProtocol:@protocol(YYAnimatedImage)]) {
            return ;
        }
        UIPanGestureRecognizer *gesture = sender;
        CGPoint p = [gesture locationInView:gesture.view];
        CGFloat progress = p.x / gesture.view.width;
        if (gesture.state == UIGestureRecognizerStateBegan) {
            previousIsPlaying = [imgView isAnimating];
            [imgView stopAnimating];
            imgView.currentAnimatedImageIndex = img.animatedImageLoopCount * progress;
        } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
            if (previousIsPlaying) {
                [imgView startAnimating];
            }
        } else {//这里浪费15分钟==animatedImageFrameCount==和==animatedImageLoopCount==傻傻没分清
            imgView.currentAnimatedImageIndex = img.animatedImageFrameCount * progress;
        }
    }];
    
    panG.delegate = self;
    [imgView addGestureRecognizer:panG];
}
//TODO: 干嘛用？？
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
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
