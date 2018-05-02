//
//  CPInfoView.h
//  CSport
//
//  Created by MacBook Pro on 2018/4/28.
//  Copyright © 2018年 caopei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CPActionTypeLogin,
    CPActionTypeLogOut,
    CPActionTypeStart,
    CPActionTypeRest,
    CPActionTypeEnd,
} CPActionType;

typedef void (^actionTypeCallBack)(CPActionType actionType);

@interface CPInfoView : UIView

@property (nonatomic, copy) actionTypeCallBack actionTypeCallback;

-(instancetype)initWithFrame:(CGRect)frame callBack:(actionTypeCallBack)actionTypeCallback;

-(void)updateUserInfo:(NSString *)nickName password:(NSString *)password;

-(void)updateDistance:(CGFloat)distance;

-(void)updateStepCount:(NSInteger)stepCount;

@end
