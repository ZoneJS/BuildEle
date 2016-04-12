//
//  UIControl+JSAddition.h
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/4/10.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JSTouchUpBlock)(id sender);

@interface UIControl (JSAddition)

@property (nonatomic, copy) JSTouchUpBlock js_touchUpBlock;

@end
