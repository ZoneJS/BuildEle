//
//  JSParentTController.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/5/24.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSParentTController.h"
#import "JSChildTVC.h"

static const CGFloat btnW = 120.f;

@interface JSParentTController () <UIScrollViewDelegate>{
    UIScrollView *_titlesView;
    UIScrollView *_contentView;
    NSMutableArray *_titles;
    NSMutableArray *_childVCs;
}

@end

@implementation JSParentTController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //!!!: iOS7之后,导航控制器下所有ScrollView都会添加额外滚动区域,坑啊！怪不得不设置这个上面会空一块
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    JSChildTVC *vc = [JSChildTVC new];
    JSChildTVC *vc1 = [JSChildTVC new];
    JSChildTVC *vc2 = [JSChildTVC new];
    JSChildTVC *vc3 = [JSChildTVC new];
    JSChildTVC *vc4 = [JSChildTVC new];
    vc.view.backgroundColor = [UIColor blueColor];
    vc1.view.backgroundColor = [UIColor grayColor];
    vc2.view.backgroundColor = [UIColor greenColor];
    vc3.view.backgroundColor = [UIColor redColor];
    vc4.view.backgroundColor = [UIColor orangeColor];
    
    if (_childVCs == nil) {
        _childVCs = [NSMutableArray array];
    }
    [_childVCs addObject:vc];
    [_childVCs addObject:vc1];
    [_childVCs addObject:vc2];
    [_childVCs addObject:vc3];
    [_childVCs addObject:vc4];
    
    [self setupChildsVC];
    [self setupTitlesView];
}

- (void)setupChildsVC {
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, kScreenWidth, kScreenHeight - 108)];
    for (int i = 0; i < 5; i++) {
        UIViewController *vc = _childVCs[i];
        [_contentView addSubview:vc.view];
        vc.view.frame = CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight);
    }
    _contentView.contentSize = CGSizeMake(kScreenWidth * 5, kScreenHeight - 108);
    _contentView.pagingEnabled = YES;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.delegate = self;
    [self.view addSubview:_contentView];
}

- (void)setupTitlesView {
    //添加子控制器
    for (UIViewController *vc in _childVCs) {
        [self addChildViewController:vc];
    }
    
    //设置标题view
    if (_titles == nil) {
        _titles = [NSMutableArray array];
    }
    for (int i = 0; i < 5; i++) {
        NSString *title = [NSString stringWithFormat:@"标题%d", i];
        [_titles addObject:title];
    }
    _titlesView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 44)];
    _titlesView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:.6];
    _titlesView.pagingEnabled = YES;
    _titlesView.showsHorizontalScrollIndicator = NO;
    _titlesView.bounces = NO;//禁止弹动
    [self.view addSubview:_titlesView];
    _titlesView.contentSize = CGSizeMake(btnW * _titles.count, 44);
    for (int i = 0; i < _titles.count; i++) {
        //        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW * i, -44, btnW, 43.5)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnW * i, 0, btnW, 43.5);
        [btn addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
        [_titlesView addSubview:btn];
        btn.tag = 10 + i;
        btn.layer.borderWidth = .5;
        btn.layer.borderColor = [UIColor grayColor].CGColor;
    }
}

- (void)btnAct:(UIButton *)btn {
    long index = btn.tag - 10;
    
    CGFloat offsetx = index * kScreenWidth;
    _contentView.contentOffset = CGPointMake(offsetx, 0);
//    [_contentView setContentOffset:CGPointMake(offsetx, 0) animated:YES];
    [self setTitleBtnMiddle:btn];
}

- (void)setTitleBtnMiddle:(UIButton *)btn {
    CGFloat offsetx = kScreenWidth / 2 - btn.center.x;
    
    if (btn.tag > 1) {
        [_titlesView setContentOffset:CGPointMake(-offsetx, 0) animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat page = scrollView.contentOffset.x / kScreenWidth;
    
    UIButton *btn = [self.view viewWithTag:page + 10];
    if (page > 1) {
        [self setTitleBtnMiddle:btn];
    }
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
