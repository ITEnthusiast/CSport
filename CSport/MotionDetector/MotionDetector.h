//
//  MotionDetector.h
//  MotionDetection
//
//  Created by qianfeng on 16/2/19.
//  Copyright © 2016年 caopei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationManager.h"
#import <CoreMotion/CoreMotion.h>
@class MotionDetector;//运动探测器
typedef enum {
    MotionTypeNotmoving = 1,
    MotionTypeWalking,
    MotionTypeRunning,
    MotionTypeAutomotive
}MotionType;

@protocol MotionDetectorDelegate <NSObject>

@optional
- (void)motionDetector:(MotionDetector *)motionDetector motionTypeChanged:(MotionType)motionType;//运动类型改变

- (void)motionDetector:(MotionDetector *)motionDetector locationChanged:(CLLocation *)location;

- (void)motionDetector:(MotionDetector *)motionDetector accelerationChanged:(CMAcceleration)acceleration;//加速度改变

@end

@interface MotionDetector : NSObject

+ (MotionDetector *)sharedInstance;


@property (weak,nonatomic)id<MotionDetectorDelegate> delegate DEPRECATED_MSG_ATTRIBUTE(" Use blocks instead");

@property (copy) void (^motionTypeChangeBlock) (MotionType motionType);

@property (copy) void (^ locationChangeBlock) (CLLocation * location);

@property (copy) void (^ accelerationChangedBlock) (CMAcceleration acceleration);//加速度改变

@property (nonatomic,readonly)MotionType motionType;

@property (nonatomic,readonly)double currentSpeed;

@property (nonatomic,readonly)CMAcceleration acceleration;

@property (nonatomic,readonly)BOOL isShaking;

- (void)startDetection;

- (void)stopDetection;

@property (nonatomic)BOOL useM7IFAvailable NS_AVAILABLE_IOS(7_0);


- (void)setMinimumSpeed:(CGFloat)speed;

- (void)setMaximumWalkingSpeed:(CGFloat)speed;

- (void)setMaximumRunningSpeed:(CGFloat)speed;

- (void)setMinimumRunningAcceleration:(CGFloat)acceleration;
@end
