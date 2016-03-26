//
//  JSTextAttributeExampleVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/3/25.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSTextAttributeExampleVC.h"
#import "YYKit.h"

@interface JSTextAttributeExampleVC ()

@end

@implementation JSTextAttributeExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableAttributedString *string = [NSMutableAttributedString new];
    //shodow text
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"阴影"];
        str.font = [UIFont boldSystemFontOfSize:30];
        str.color = [UIColor whiteColor];
        
        YYTextShadow *shadow = [YYTextShadow new];
        shadow.color = [UIColor greenColor];
        shadow.offset = CGSizeMake(0, 1);
        str.textShadow = shadow;
        [str appendAttributedString:[self pad]];
        [string appendAttributedString:str];
    }
    
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"带下划线的链接"];
        str.font = [UIFont boldSystemFontOfSize:30];
        str.color = [UIColor blueColor];
        str.underlineStyle = YYTextLineStyleSingle;
        
        @weakify(self);
        [str setTextHighlightRange:str.rangeOfAll
                             color:[UIColor blueColor]
                   backgroundColor:[UIColor lightGrayColor]
                         tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
          @strongify(self);
            [self showMsg:[NSString stringWithFormat:@"tap: %@!!!",[text.string substringWithRange:range]]];
        }];
        
        [string appendAttributedString:str];
        [string appendAttributedString:[self pad]];
    }
    
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"有一个圈圈包起来的链接，，，，，，点击后还会出现神奇的效果"];
        str.font = [UIFont boldSystemFontOfSize:20];
        str.color = [UIColor redColor];
        
        YYTextBorder *border = [YYTextBorder new];
        border.strokeColor = str.color;
        border.cornerRadius = 50;
        border.insets = UIEdgeInsetsMake(0, -10, 0, -10);
        border.strokeWidth = .5;
        border.lineStyle = YYTextLineStyleSingle;
        str.textBackgroundBorder = border;
        
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setColor:[UIColor whiteColor]];
        
        YYTextBorder *highlightBorder = border.copy;//!!!: 一开始用了［border new］结果背景变红的是矩形
        highlightBorder.strokeWidth = 0;
        highlightBorder.strokeColor = [UIColor redColor];
        highlightBorder.fillColor = [UIColor redColor];
        [highlight setBackgroundBorder:highlightBorder];
        @weakify(self);
        highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            @strongify(self);
            [self showMsg:[NSString stringWithFormat:@"tap: %@",[text.string substringWithRange:range]]];
        };
        
        [str setTextHighlight:highlight range:str.rangeOfAll];
        [string appendAttributedString:str];
        [string appendAttributedString:[self pad]];
    }

//    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
    YYLabel *label = [YYLabel new];
    label.backgroundColor = [UIColor brownColor];
    label.attributedText = string;
    label.width = kScreenWidth;
    label.height = kScreenHeight - 64;
    label.top = 64;
    label.textAlignment = NSTextAlignmentCenter;//!!!: 居中对齐
    label.numberOfLines = 0;
    [self.view addSubview:label];
    label.centerX = self.view.centerX;
    label.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 10);
//    label.width = self.view.width;
//    label.height = self.view.height - (kiOS7Later ? 64 : 44);
//    label.top = (kiOS7Later ? 64 : 0);
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
//    label.numberOfLines = 0;
//    label.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
//    [self.view addSubview:label];

    // Do any additional setup after loading the view.
}

- (NSAttributedString *)pad {
    NSMutableAttributedString *pad = [[NSMutableAttributedString alloc] initWithString:@"\n\n"];
    pad.font = [UIFont systemFontOfSize:4];
    return pad;
}

- (void)showMsg:(NSString *)msg {
    CGFloat padding = 10;
    
    YYLabel *label = [YYLabel new];
    [self.view addSubview:label];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor blueColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.text = msg;
    label.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);//!!!: 正数是向内间距
    label.width = kScreenWidth;
    label.height = padding * 2 + [label.text heightForFont:label.font width:label.width];
    label.bottom = 64;

    [UIView animateWithDuration:0.3 animations:^{
        label.top = 64;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            label.bottom = 64;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
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
