//
//  JSRequestVM.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/15.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSRequestVM.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@implementation JSRequestVM

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIImageView *imgV) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//            mgr.responseSerializer = [AFJSONResponseSerializer ]
//            [mgr GET:@"http://img5.imgtn.bdimg.com/it/u=3425851328,2681317699&fm=21&gp=0.jpg" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation,id _Nonnull responseObject) {
//                UIImage *img = [UIImage imageWithData:responseObject];
//                [subscriber sendNext:img];
//            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//                [subscriber sendNext:nil];
//            }];
            
//            [imgV sd_setImageWithURL:[NSURL URLWithString:@"http://img5.imgtn.bdimg.com/it/u=3425851328,2681317699&fm=21&gp=0.png"]];
            [subscriber sendNext:[UIImage imageNamed:@"pia"]];
            return nil;
        }];
    }];
}

@end
