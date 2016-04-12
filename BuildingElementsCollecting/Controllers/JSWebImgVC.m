//
//  JSWebImgVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/3/26.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSWebImgVC.h"

#import "YYKit.h"

#define kCellHeight ceil(kScreenWidth * 3.0 / 4.0)

@interface JSWebImgCell : UITableViewCell
@property (nonatomic, strong) YYAnimatedImageView *webImgView;
@property (nonatomic, strong) UILabel *tipLbl;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@end

@implementation JSWebImgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.size = CGSizeMake(kScreenWidth, kCellHeight);
    self.contentView.size = self.size;//???: 有必要吗
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _webImgView = [YYAnimatedImageView new];
    _webImgView.size = self.contentView.size;
    _webImgView.backgroundColor = [UIColor whiteColor];
    _webImgView.contentMode = UIViewContentModeScaleAspectFill;
    _webImgView.clipsToBounds = YES;
    [self.contentView addSubview:_webImgView];
    
    _tipLbl = [UILabel new];
    _tipLbl.size = self.size;
    _tipLbl.textAlignment = NSTextAlignmentCenter;
    _tipLbl.text = @"Load fail, 点击重新加载";
    _tipLbl.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    _tipLbl.userInteractionEnabled = YES;
    _tipLbl.hidden = YES;
    [self.contentView addSubview:_tipLbl];
    
    CGFloat lineH = 4;
    _progressLayer = [CAShapeLayer layer];//???: 什么东东，有时间看一下
    _progressLayer.size = CGSizeMake(_webImgView.width, lineH);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, lineH / 2)];
    [path addLineToPoint:CGPointMake(_webImgView.width, lineH / 2)];
    _progressLayer.lineWidth = lineH;
    _progressLayer.path = path.CGPath;
    _progressLayer.strokeColor = [UIColor colorWithRed:0 green:0.64 blue:1.00 alpha:1].CGColor;
    _progressLayer.lineCap = kCALineCapButt;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    [_webImgView.layer addSublayer:_progressLayer];
    
    @weakify(self);
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        [self setImgUrl:self.webImgView.imageURL];
    }];
    [_tipLbl addGestureRecognizer:g];
    
    return self;
}

- (void)setImgUrl:(NSURL *)url {
    _tipLbl.hidden = YES;
    
    [CATransaction begin];//???: 什么鬼
    [CATransaction setDisableActions:YES];
    _progressLayer.hidden = YES;
    _progressLayer.strokeEnd = 0;
    [CATransaction commit];
    
    @weakify(self);
    [_webImgView setImageWithURL:url
                     placeholder:nil
                         options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation
                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            if (expectedSize > 0 && receivedSize > 0) {
                                CGFloat progress = (CGFloat)receivedSize / expectedSize;
                                progress = progress < 0 ? 0 : progress > 1 ? 1 : progress;
                                @strongify(self);
                                if (self.progressLayer.hidden) {
                                    self.progressLayer.hidden = NO;
                                }
                                self.progressLayer.strokeEnd = progress;
                            }
                        } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                            @strongify(self);
                            if (stage == YYWebImageStageFinished) {
                                self.progressLayer.hidden = YES;
                                if (!image) {
                                    self.tipLbl.hidden = NO;
                                }
                            }
                        }];
}

@end

@interface JSWebImgVC ()<UITableViewDelegate, UITableViewDataSource> {
    NSArray *_imgLinks;
    UITableView *_mainView;
}
//@property (nonatomic, strong) UITableView *mainView;
@end

@implementation JSWebImgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.027 alpha:1];
    
    _mainView = [UITableView new];
    _mainView.size = self.view.frame.size;
    _mainView.backgroundColor = [UIColor clearColor];
    _mainView.delegate = self;
    _mainView.dataSource = self;
    [_mainView registerClass:[JSWebImgCell class] forCellReuseIdentifier:@"id"];
    _mainView.rowHeight = kCellHeight;
    _mainView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStylePlain target:self action:@selector(reload)];
    self.navigationItem.rightBarButtonItem = item;
    
    _imgLinks = @[
                  /*
                   You can add your image url here.
                   */
                  
                  // progressive jpeg
                  @"https://s-media-cache-ak0.pinimg.com/1200x/2e/0c/c5/2e0cc5d86e7b7cd42af225c29f21c37f.jpg",
                  
                  // animated gif: http://cinemagraphs.com/
                  @"http://i.imgur.com/uoBwCLj.gif",
                  @"http://i.imgur.com/8KHKhxI.gif",
                  @"http://i.imgur.com/WXJaqof.gif",
                  
                  // animated gif: https://dribbble.com/markpear
                  @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1780193/dots18.gif",
                  @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1809343/dots17.1.gif",
                  @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1845612/dots22.gif",
                  @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1820014/big-hero-6.gif",
                  @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1819006/dots11.0.gif",
                  @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1799885/dots21.gif",
                  
                  // animaged gif: https://dribbble.com/jonadinges
                  @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/2025999/batman-beyond-the-rain.gif",
                  @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1855350/r_nin.gif",
                  @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1963497/way-back-home.gif",
                  @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1913272/depressed-slurp-cycle.gif",
                  
                  // jpg: https://dribbble.com/snootyfox
                  @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2047158/beerhenge.jpg",
                  @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
                  @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1839353/pilsner.jpg",
                  @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1833469/porter.jpg",
                  @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1521183/farmers.jpg",
                  @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1391053/tents.jpg",
                  @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1399501/imperial_beer.jpg",
                  @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1488711/fishin.jpg",
                  @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1466318/getaway.jpg",
                  
                  // animated webp and apng: http://littlesvr.ca/apng/gif_apng_webp.html
                  @"http://littlesvr.ca/apng/images/BladeRunner.png",
                  @"http://littlesvr.ca/apng/images/Contact.webp",
                  ];
    [_mainView reloadData];
    [self scrollViewDidScroll:_mainView];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _imgLinks.count * 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSWebImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id" forIndexPath:indexPath];
    [cell setImgUrl:[NSURL URLWithString:_imgLinks[indexPath.row % _imgLinks.count]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {//???: 不太懂
    CGFloat viewH = scrollView.height + scrollView.contentInset.top;//667 - 64
    
    for (JSWebImgCell *cell in _mainView.visibleCells) {
        CGFloat y = cell.centerY - scrollView.contentOffset.y;
        CGFloat p = y - viewH / 2;
        CGFloat scale = cos(p / viewH * 0.8) * 0.95;
        NSLog(@"\n y:%lf\n p:%lf\n scale:%lf", y, p, scale);
        if ([UIDevice systemVersion] >= 8) {
            [UIView animateWithDuration:0.15
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 cell.webImgView.transform = CGAffineTransformMakeScale(scale, scale);
                             } completion:NULL];
        } else {
            cell.webImgView.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }

}
- (void)reload {
    [[YYImageCache sharedCache].memoryCache removeAllObjects];
    [[YYImageCache sharedCache].diskCache removeAllObjects];
    [_mainView performSelector:@selector(reloadData) afterDelay:0.1];
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
