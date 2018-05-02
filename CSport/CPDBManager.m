//
//  CPDBManager.m
//  CSport
//
//  Created by MacBook Pro on 2018/5/1.
//  Copyright © 2018年 caopei. All rights reserved.
//

#import "CPDBManager.h"

@implementation CPDBManager
-(instancetype)init {
    if (self = [super init]) {
        _mArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_mArray forKey:@"_mArray"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _mArray = [aDecoder decodeObjectForKey:@"_mArray"];
    }
    return self;
}

@end
