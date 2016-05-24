//
//  NSObject+JSModel.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/5/23.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "NSObject+JSModel.h"
#import <objc/message.h>

@implementation NSObject (JSModel)

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    //思路：便利模型中的所有属性-->使用运行时
    
    //0.创建对应的对象
    id objc =  [[self alloc] init];
    
//    1.利用runtime给对象的成员属性赋值
//        class_copyIvarList:获取类中所有成员属性
    //class cls 要获取成员属性的类
    //int *outCount 表示这个类有多少成员属性，传入int 变量地址会自动给这个地址赋值
//        class_copyIvarList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)

/* 写法：
    Ivar ivar;
    Ivar ivar1;
    Ivar ivar2;
    //定义一个ivar的数组a
    Ivar a[] = {ivar, ivar1, ivar2};
    //用一个Ivar *指针指向数组的第一个元素
    Ivar *ivarList = a;
    //根据指针访问数组的第一个元素
    ivarList[0];
    ivarList[1];
*/
    unsigned int count;
    //获取类中所有属性
    Ivar *ivarList = class_copyIvarList(self, &count);
    
    for (int i = 0; i < count; i++) {
        //根据角标，从数组取出对应的成员属性
        Ivar ivar = ivarList[i];
        
        //获取成员属性名
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        //处理成员属性名-->字典中的key
        //从第一个角标开始截取
        NSString *key = [name substringFromIndex:1];
        
        //根据成员属性名去字典查找对应的value
        id value = dict[key];
        
        //二级转换：如果字典中还有字典，要把对应的字典转模型
        if ([value isKindOfClass:[NSDictionary class]]) {
            //字典转模型
            //获取模型的类对象，调用modelWithDict
            //模型的类名已知，就是成员属性的类型
            
            //获取成员属性类型
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            //生成诸如@"@\"User\"",在oc字符串中\"-->"，\是转义的意思，不占用字符
            //裁剪类型字符串
            NSRange range = [type rangeOfString:@"\""];
            type = [type substringFromIndex:range.location + range.length];
            range = [type rangeOfString:@"\""];
            
            //裁剪到哪个角标，不包括当前角标
            type = [type substringToIndex:range.location];
            
            //根据字符串类名生成类对象
            Class modelClass = NSClassFromString(type);
            
            if (modelClass) {
                value = [modelClass modelWithDict:value];
            }
        }
        
        //判断是数组的话数组中的字典转模型
        if ([value isKindOfClass:[NSArray class]]) {
            //判断是否实现字典数组转模型数组的协议
            if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
                //转换id类型，就能调用任何对象方法
                id idSelf = self;
                
                //获取数组中字典对应的模型
                NSString *type = [idSelf arrayContainModelClass][key];
                
                //生成模型
                Class classModel = NSClassFromString(type);
                NSMutableArray *arrm = [NSMutableArray array];
                //便利字典数组,生成模型数组
                for (NSDictionary *dict in value) {
                    //字典转模型
                    id model = [classModel modelWithDict:dict];
                    [arrm addObject:model];
                }
                
                //把模型赋值给value
                value = arrm;
            }
        }
        
        if (value) {//兼容判断吧
            [objc setValue:value forKey:key];
        }
    }
    
    return objc;
}

@end
