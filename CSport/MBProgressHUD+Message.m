//
//  MBProgressHUD+Message.m
//  LawyerCenter
//
//  Created by kelei on 15/7/22.
//  Copyright (c) 2015年 caopei. All rights reserved.
//

#import "MBProgressHUD+Message.h"

@implementation MBProgressHUD (Message)

+ (instancetype)_sharedHUD {
    static MBProgressHUD *instance = nil;
    static dispatch_once_t onceToken;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithWindow:window];
    });
    if (!instance.superview) {
        [window addSubview:instance];
    }
    return instance;
}

+ (void)showSuccessWithMessage:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:window];
    [window addSubview:hud];
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    hud.color = k_COLOR_WHITE;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_common_ok"]];
    hud.detailsLabelText = message;
    hud.detailsLabelColor = k_COLOR_BLACK;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}

+ (void)showErrorWithMessage:(NSString *)message {
    NSParameterAssert(message);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:window];
    [window addSubview:hud];
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    hud.color = k_COLOR_WHITE;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_common_no"]];
    hud.detailsLabelText = message;
    hud.detailsLabelColor = k_COLOR_BLACK;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}

+ (void)showErrorWithMessage:(NSString *)message offsetY:(CGFloat)offsetY {
    NSParameterAssert(message);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:window];
    [window addSubview:hud];
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.color = k_COLOR_WHITE;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_common_no"]];
    hud.detailsLabelText = message;
    hud.detailsLabelColor = k_COLOR_BLACK;
    hud.yOffset = offsetY;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}

+ (void)showLoadingWithMessage:(NSString *)message {
    MBProgressHUD *hud = [self _sharedHUD];
    hud.userInteractionEnabled = YES;
    hud.removeFromSuperViewOnHide = YES;
    hud.color = k_COLOR_WHITE;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.detailsLabelText = message;
    hud.detailsLabelColor = k_COLOR_BLACK;
    [hud show:YES];
}

+ (void)hideLoading {
    MBProgressHUD *hud = [self _sharedHUD];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES];
}

@end
