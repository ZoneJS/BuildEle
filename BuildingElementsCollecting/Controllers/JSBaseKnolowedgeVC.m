//
//  JSBaseKnolowedgeVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/11.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSBaseKnolowedgeVC.h"

@implementation JSBaseKnolowedgeVC

//正则表达式
- (void)regularTest {
    //正则表达式
    NSString *str = @"你已接到一个<color>手机淘宝垫付任务</color>，请在<color>2小时内</color>完成并提交任务";
    //创建正则表达式对象
    NSString *pattern = @"<color>[0-9a-zA-Z\\u4e00-\\u9fa5]+</color>";
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    //利用正则表达式测试对应的字符串
    NSArray *results = [regular matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    for (NSTextCheckingResult *result in results) {
        NSLog(@"%@ %@",NSStringFromRange(result.range),[str substringWithRange:result.range]);
    }
    /* 常用的规则
     []:找到内部的某一个字符
     [a-zA-Z0-9]:代表字符或数字
     \\d:代表数字
     {2}:代表有两个
     {2,4}:代表有2到4个
     ?:代表0个或一个
     +:代表至少1个
     *:代表0个或多个
     ^:代表以...开头
     $:代表以...结束
     .:代表除换行符以外的任意字符
     */
    
    NSString *p;
    //s实例：
    //表示一个数字字符
    p = @"\\d";
    //表示2到5个连续的数字
    p = @"\\d{2,5}";
    //qq账户的正则表达式
    p = @"^[1-9]\\d{4,10}";
    //电话号码正则表达式
    p = @"^((13[0-9])|(15[3-5])|(18[0-9]))\\d{8}$";
    //邮箱正则表达式
    p = @"^.*@..+\\.[a-zA-Z]{2,4}$";
    
    //例子：
    NSString *s1 = @"#今日要闻#[偷笑]http://www.baidu.com/ass/1e @ads[test] #你确定#@rain里23:@张三[挖鼻屎]m123m";
    //表情正则表达式 \\u4e00-\\u9fa5 代表unicode字符
    NSString *p1 = @"\\[[a-zA-Z\\u4e00-\\u9fa5]+\\]";
    //@正则表达式
    NSString *p2 = @"@[0-9a-zA-Z\\u4e00-\\u9fa5]+";
    //#...#正则表达式
    NSString *p3 = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    //url
    //    NSString *p4 = @"\\b"
    //设定总的表达式
    NSString *pp = [NSString stringWithFormat:@"%@|%@|%@", p1, p2, p3];
    NSRegularExpression *regular1 = [[NSRegularExpression alloc] initWithPattern:pp options:NSRegularExpressionCaseInsensitive error:nil];
    //获取匹配结果
    NSArray *rs = [regular1 matchesInString:s1 options:0 range:NSMakeRange(0, s1.length)];
    for (NSTextCheckingResult *r in rs) {
        NSLog(@"%@ %@\n",NSStringFromRange(r.range), [s1 substringWithRange:r.range]);
    }
}
@end
