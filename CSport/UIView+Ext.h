//
//  UIView+Ext.h
//  LawyerCenter
//
//  Created by kelei on 15/7/28.
//  Copyright (c) 2015年 caopei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Ext)

/**
 *  查找当前View中被激活的对象
 *
 *  @return 激活的对象
 */
- (instancetype)findFirstResponder;

/**
 *  传入view是当前view的subview(递归)
 *
 *  @param view 需要检查的view
 *
 *  @return YES:包含 NO:不包含
 */
- (BOOL)containsTheView:(UIView *)view;

/**
 *  返回当前view所在的ViewController
 *
 *  @return 当前view所在的ViewController
 */
- (UIViewController *)parentViewController;

@end
