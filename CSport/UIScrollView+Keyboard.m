//
//  UIScrollView+Keyboard.m
//  Sunflower
//
//  Created by kelei on 15/7/5.
//  Copyright (c) 2015年 caopei. All rights reserved.
//

#import "UIScrollView+Keyboard.h"
#import "UIView+Ext.h"

@implementation UIScrollView (Keyboard)

- (void)handleKeyboard {
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    _weak(self);
    __block BOOL handled = NO;
    [self addObserverForNotificationName:UIKeyboardWillShowNotification usingBlock:^(NSNotification *notification) {
        _strong(self);
        UIView *activeField = [self findFirstResponder];
        if (activeField) {
            handled = YES;
            
            CGFloat tabBarHeight = 0;
            UIViewController *vc = [self parentViewController];
            if (vc && vc.tabBarController)
                tabBarHeight = vc.tabBarController.tabBar.frame.size.height;
            
            NSDictionary* info = [notification userInfo];
            CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
            kbSize.height -= tabBarHeight;
            
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
            self.contentInset = contentInsets;
            self.scrollIndicatorInsets = contentInsets;
            
            CGRect rect = self.bounds;
            rect.size.height -= kbSize.height;
            CGRect activeFieldFrame = [self convertRect:activeField.bounds fromView:activeField];
            CGPoint activePoint = CGPointMake(activeFieldFrame.origin.x, CGRectGetMaxY(activeFieldFrame));
            if (activePoint.y > CGRectGetMaxY(rect)) {
                CGPoint point = CGPointMake(0, activePoint.y - rect.size.height);
                [self setContentOffset:point animated:YES];
            }
            else if (activePoint.y < CGRectGetMinY(rect)) {
                CGPoint point = CGPointMake(0, activePoint.y);
                [self setContentOffset:point animated:YES];
            }
        }
    }];
    [self addObserverForNotificationName:UIKeyboardWillHideNotification usingBlock:^(NSNotification *notification) {
        _strong(self);
        if (handled) {
            UIEdgeInsets contentInsets = UIEdgeInsetsZero;
            self.contentInset = contentInsets;
            self.scrollIndicatorInsets = contentInsets;
            handled = NO;
        }
    }];
}

@end
