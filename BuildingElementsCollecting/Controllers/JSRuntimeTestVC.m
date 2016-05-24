//
//  JSRuntimeTestVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/4/10.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSRuntimeTestVC.h"
#import "NSString+JSAdditions.h"
#import "JSPerson.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UIImage+Image.h"
#import "NSObject+JSProperty.h"
#import "Status1.h"
#import "Status.h"
#import "NSObject+JSLog.h"

@interface JSRuntimeTestVC ()

@end

@implementation JSRuntimeTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Method originalMethod = class_getClassMethod([NSString class], @selector(lowercaseString));
    Method swappedMethod = class_getClassMethod([NSString class], @selector(js_myLowercaseString));
    method_exchangeImplementations(originalMethod, swappedMethod);
    
    NSString *str = @"zjs test for swap method in runtime";
    str = [str lowercaseString];
    
    JSPerson *p = [[JSPerson alloc] init];
    p.name = @"hehe";
    [p testMethod];
    [p method4swap];
//    ???:无效呢
    //本质让对象发送消息
//    objc_msgSend(p, @selector(testMethod));
    
    //类对象发送消息
    objc_msgSend([JSPerson class], @selector(classTestMethod));
    
    UIImage *img = [UIImage imageWithName:nil];
    UIImage *img2 = [UIImage imageWithName:@"pia"];
    
    //动态添加方法
    [p performSelector:@selector(eat)];
    
    //动态添加属性
    //在分类中声明get，set方法，本质不是生成
    NSObject *objc = [[NSObject alloc] init];
    objc.name = @"hello";
    NSLog(@"动态添加的属性名字是：%@", objc.name);
    
    //字典解析(kvc)
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"status.plist" ofType:nil];
    NSDictionary *statusDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *dictArr = statusDict[@"statuses"];
    [NSObject resolveDict:dictArr[0]];
    NSMutableArray *statues = [NSMutableArray array];
    for (NSDictionary *dict in dictArr) {
        Status1 *status = [Status1 statusWithDict:dict];
        [statues addObject:status];
    }
    Status1 *s0 = [Status1 statusWithDict:dictArr[0]];
    NSLog(@"kvc归档后的模型数组:%@", s0.user);//这里使用kvc的话json里面的字典还是字典，数组还是数组
    
    NSMutableArray *statues2 = [NSMutableArray array];
    for (NSDictionary *dict in dictArr) {
        Status *status = [Status modelWithDict:dict];
        [statues2 addObject:status];
    }
    Status *s1 = [Status modelWithDict:dictArr[0]];
    NSLog(@"模型user:%@", s1.user);
    
    size_t size = class_getInstanceSize(p.class);
    NSLog(@"size = %ld", size);
    
    for (NSString *propertyName in p.allProperties) {
        NSLog(@"%@", propertyName);
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//对象拷贝
- (void)copyObj {
    JSRuntimeTestVC *obj = [JSRuntimeTestVC new];
    
    
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
