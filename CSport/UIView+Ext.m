//
//  UIView+Ext.m
//  LawyerCenter
//
//  Created by kelei on 15/7/28.
//  Copyright (c) 2015年 caopei. All rights reserved.
//

#import "UIView+Ext.h"

@implementation UIView (Ext)

- (instancetype)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        id view = [subView findFirstResponder];
        if (view) {
            return view;
        }
    }
    return nil;
}

- (BOOL)containsTheView:(UIView *)view {
    if (self == view) {
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView containsTheView:view]) {
            return YES;
        }
    }
    return NO;
}

- (UIViewController *)parentViewController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]])
        responder = [responder nextResponder];
    if ([responder isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)responder;
    }
    return nil;
}

@end
