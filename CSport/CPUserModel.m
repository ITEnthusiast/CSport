//
//  CPUserModel.m
//  CSport
//
//  Created by MacBook Pro on 2018/5/1.
//  Copyright © 2018年 caopei. All rights reserved.
//

#import "CPUserModel.h"

@implementation CPUserModel

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_nickName forKey:@"_nickName"];
    [aCoder encodeObject:_password forKey:@"_password"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _nickName = [aDecoder decodeObjectForKey:@"_nickName"];
        _password = [aDecoder decodeObjectForKey:@"_password"];
    }
    return self;
}

@end
