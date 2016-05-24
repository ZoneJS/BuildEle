//
//  Status.h
//  05-Runtime(字典转模型)
//
//  Created by yz on 15/10/13.
//  Copyright © 2015年 yz. All rights reserved.
//  for kvc use

#import <Foundation/Foundation.h>

@interface Status1 : NSObject

@property (nonatomic, strong) NSString *source;

@property (nonatomic, assign) int reposts_count;

@property (nonatomic, strong) NSArray *pic_urls;

@property (nonatomic, strong) NSString *created_at;

@property (nonatomic, assign) int attitudes_count;

@property (nonatomic, strong) NSString *idstr;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, assign) int comments_count;

@property (nonatomic, strong) NSDictionary *user;

+ (instancetype)statusWithDict:(NSDictionary *)dict;


@end
