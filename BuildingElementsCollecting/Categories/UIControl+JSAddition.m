//
//  UIControl+JSAddition.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/4/10.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "UIControl+JSAddition.h"
#import <objc/runtime.h>

static const void *sJSUIControlTouchUpEventBlockKey = "sJSUIControlTouchUpEventBlockKey";

@implementation UIControl (JSAddition)

- (void)setJs_touchUpBlock:(JSTouchUpBlock)js_touchUpBlock {//重写set方法
    objc_setAssociatedObject(self,
                             sJSUIControlTouchUpEventBlockKey,
                             js_touchUpBlock,
                             OBJC_ASSOCIATION_COPY);
    
    [self removeTarget:self action:@selector(jsOnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    
    if (js_touchUpBlock) {
        [self addTarget:self action:@selector(jsOnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (JSTouchUpBlock)js_touchUpBlock {
    return objc_getAssociatedObject(self, sJSUIControlTouchUpEventBlockKey);
}

- (void)jsOnTouchUp:(UIButton *)sender {
    JSTouchUpBlock touchUp = self.js_touchUpBlock;
    
    if (touchUp) {
        touchUp(sender);
    }
}

@end
