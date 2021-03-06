//
//  MBProgressHUD+Message.h
//  LawyerCenter
//
//  Created by kelei on 15/7/22.
//  Copyright (c) 2015年 caopei. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Message)

/**
 *  显示成功消息
 *
 *  @param message 消息内容。可以为nil
 */
+ (void)showSuccessWithMessage:(NSString *)message;

/**
 *  显示错误消息
 *
 *  @param message 消息内容。不能为nil
 */
+ (void)showErrorWithMessage:(NSString *)message;

/**
 *  显示错误消息
 *
 *  @param message 消息内容。不能为nil
 *  @param offsetY 消息框的在纵向的偏移量
 */
+ (void)showErrorWithMessage:(NSString *)message offsetY:(CGFloat)offsetY;

/**
 *  显示正在加载消息
 *
 *  @param message 消息内容。可以为nil
 */
+ (void)showLoadingWithMessage:(NSString *)message;
+ (void)hideLoading;

@end
