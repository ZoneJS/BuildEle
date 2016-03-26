//
//  JSAsyncTextVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/3/25.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSAsyncTextVC.h"

#import "YYKit.h"
#import "YYFPSLabel.h"

@interface JSExampleCell : UITableViewCell
@property (nonatomic, assign) BOOL async;
- (void)setCellText:(NSAttributedString *)string;
@end

@implementation JSExampleCell {
    UILabel *_uiLabel;
    YYLabel *_yylabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _uiLabel = [UILabel new];
    _uiLabel.font = [UIFont systemFontOfSize:8];
    _uiLabel.numberOfLines = 0;
    _uiLabel.size = CGSizeMake(kScreenWidth, 34);
    [self.contentView addSubview:_uiLabel];
    
    _yylabel = [YYLabel new];
    _yylabel.font = _uiLabel.font;
    _yylabel.numberOfLines = 0;
    _yylabel.size = _uiLabel.size;
    _yylabel.displaysAsynchronously = YES;
    _yylabel.hidden = YES;
    [self.contentView addSubview:_yylabel];
    
    
    return self;
}

- (void)setAsync:(BOOL)async {
    if (_async == async) {
        return;
    }
    _async = async;
    _uiLabel.hidden = async;
    _yylabel.hidden = !async;//开启异步显示就不隐藏
}

- (void)setCellText:(id)string {
    if (_async) {
        _yylabel.layer.contents = nil;
        _yylabel.textLayout = string;
    } else {
        _uiLabel.attributedText = string;
    }
}

@end

@interface JSAsyncTextVC () <UITableViewDelegate,UITableViewDataSource>{
    UITableView *_mainView;
    NSMutableArray *_strings;
    NSMutableArray *_layouts;
}

@property (nonatomic, assign) BOOL basync;

@end

@implementation JSAsyncTextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _basync = NO;
    
    UIView *toolBar;
    if ([UIVisualEffectView class]) {
        toolBar = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    } else {
        toolBar = [UIToolbar new];
    }
    toolBar.top = 64;
    toolBar.size = CGSizeMake(kScreenWidth, 40);
    [self.view addSubview:toolBar];
    
    YYFPSLabel *fps = [YYFPSLabel new];
    fps.centerY = toolBar.height / 2;//这里的y依据相对父视图的坐标
    fps.left = 5;
    [toolBar addSubview:fps];
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"开启异步加载cell： ";
    label.centerY = toolBar.height / 2;
    [toolBar addSubview:label];
    [label sizeToFit];//!!!: 不加不显示
    label.left = fps.right + 10;
    
    
    UISwitch *switcher = [UISwitch new];
    [toolBar addSubview:switcher];
    switcher.left = label.right + 10;
    switcher.centerY = label.centerY;
    switcher.layer.transformScale = 0.7;
    @weakify(self);
    [switcher addBlockForControlEvents:UIControlEventValueChanged block:^(id  _Nonnull sender) {
        @strongify(self);
        [self setBasync:switcher.isOn];
    }];

    _mainView = [UITableView new];
    _mainView.size = self.view.frame.size;
    [self.view insertSubview:_mainView belowSubview:toolBar];
    _mainView.rowHeight = 34;
    _mainView.delegate = self;
    _mainView.dataSource = self;
    
    NSMutableArray *strings = [NSMutableArray new];
    NSMutableArray *layouts = [NSMutableArray new];
    for (int i = 0; i < 300; i++) {
        NSString *str = [NSString stringWithFormat:@"%d Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫 Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫",i];
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
        text.font = [UIFont systemFontOfSize:10];
        text.lineSpacing = 0;
        text.strokeWidth = @(-3);
        text.strokeColor = [UIColor redColor];
        text.lineHeightMultiple = 1;
        text.maximumLineHeight = 12;
        text.minimumLineHeight = 12;
        
        NSShadow *shadow = [NSShadow new];
        shadow.shadowBlurRadius = 1;
        shadow.shadowColor = [UIColor redColor];
        shadow.shadowOffset = CGSizeMake(0, 1);
        [strings addObject:text];
        
        // it better to do layout in background queue...
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth, 34)];
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
        [layouts addObject:layout];
    }
    _strings = strings;
    _layouts = layouts;
    
}

- (void)setBasync:(BOOL)basync {
    if (_basync == basync) {
        return;
    }
    _basync = basync;
    [_mainView.visibleCells enumerateObjectsUsingBlock:^(JSExampleCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        cell.async = basync;
        NSIndexPath *indexPath = [_mainView indexPathForCell:cell];
        if (basync) {
            [cell setCellText:_layouts[indexPath.row]];
        } else {
            [cell setCellText:_strings[indexPath.row]];
        }
    }];
}

#pragma mark - UITableViewDataSource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSExampleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[JSExampleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    
    cell.async = _basync;
    if (_basync) {
        [cell setCellText:_layouts[indexPath.row]];
    } else {
        [cell setCellText:_strings[indexPath.row]];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
