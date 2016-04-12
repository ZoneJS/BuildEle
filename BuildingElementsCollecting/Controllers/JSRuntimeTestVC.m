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
