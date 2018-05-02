//
//  GCAlertView.h
//  cosmoiphone
//
//  Created by makewei on 15/10/27.
//  Copyright (c) 2015年 MCI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCAlertView : UIView

@property(nonatomic,readonly,getter=isVisible) BOOL visible;

- (instancetype)initWithTitle:(NSString *)title andMessage:(NSString *)message;

- (void)setCancelButtonWithTitle:(NSString *)cancelTitle actionBlock:(void(^)())cancelBlock;
- (void)addOtherButtonWithTitle:(NSString *)otherTitle actionBlock:(void(^)())otherBlock;

- (void)show;

@end
