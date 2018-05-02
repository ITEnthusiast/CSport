//
//  CPUserModel.h
//  CSport
//
//  Created by MacBook Pro on 2018/5/1.
//  Copyright © 2018年 caopei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPUserModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *password;

@end
