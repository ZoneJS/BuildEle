//
//  JSPerson.h
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/4/10.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  @interface NSObject <NSObject> {
 Class isa  OBJC_ISA_AVAILABILITY;
 }
 */
@interface JSPerson : NSObject {
    NSString *_variableString;
}

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSMutableArray *array;

- (NSArray *)allProperties;

@end
