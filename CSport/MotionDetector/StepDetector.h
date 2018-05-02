//
//  StepDetector.h
//  MotionDetection
//
//  Created by qianfeng on 16/2/20.
//  Copyright © 2016年 caopei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StepDetector : NSObject

+ (instancetype)sharedInstance;

/**
 * Start accelerometer updates.
 * @param callback Will be called every time when new step is detected
 */
- (void)startDetectionWithUpdateBlock:(void(^)(NSError *error))callback;

/**
 * Stop motion manager accelerometer updates
 */
- (void)stopDetection;
@end
