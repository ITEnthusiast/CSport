//
//  MotionDetector.m
//  MotionDetection
//
//  Created by qianfeng on 16/2/19.
//  Copyright © 2016年 caopei. All rights reserved.
//

#import "MotionDetector.h"

CGFloat kMinimumSpeed        = 0.3f;
CGFloat kMaximumWalkingSpeed = 1.9f;
CGFloat kMaximumRunningSpeed = 7.5f;
CGFloat kMinimumRunningAcceleration = 3.5f;

@interface MotionDetector ()

@property (strong,nonatomic)NSTimer * shakeDetectingTimer;

@property (nonatomic,strong)CLLocation * currentLocation;

@property (nonatomic)MotionType previousMotionType;//以前的运动类型

//加速度管理
@property (nonatomic,strong)CMMotionManager * motionManager;

@property (nonatomic,strong)CMMotionActivityManager * motionActivityManager;

@end
@implementation MotionDetector

+ (MotionDetector *)sharedInstance{
    static MotionDetector * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleLocationChangedNotification:) name:LOCATION_DID_CHANGED_NOTIFICATION object:nil];
        self.motionManager = [[CMMotionManager alloc]init];
        
        // 加速度器的检测
        if ([self.motionManager isAccelerometerAvailable]){
            NSLog(@"Accelerometer is available.");
        } else{
            NSLog(@"Accelerometer is not available.");
        }
        if ([self.motionManager isAccelerometerActive]){
            NSLog(@"Accelerometer is active.");
        } else {
            NSLog(@"Accelerometer is not active.");
        }
        
        // 陀螺仪的检测
        if([self.motionManager isGyroAvailable]){
            NSLog(@"Gryro is available.");
        } else {
            NSLog(@"Gyro is not available.");
        }
        if ([self.motionManager isGyroActive]){
            NSLog(@"Gryo is active.");
            
        } else {
            NSLog(@"Gryo is not active.");
        }
    }
    return self;
}

+ (BOOL)motionHardwareAvailable
{
    static BOOL isAvailable = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        isAvailable = [CMMotionActivityManager isActivityAvailable];
    });
    return isAvailable;
}

- (void)startDetection
{
    [[LocationManager sharedInstance] start];
    
    self.shakeDetectingTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(detectShaking) userInfo:Nil repeats:YES];
    
    [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        _acceleration = accelerometerData.acceleration;
        [self calculateMotionType];  //计算运动方式
        dispatch_async(dispatch_get_main_queue(), ^{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            if (self.delegate && [self.delegate respondsToSelector:@selector(motionDetector:accelerationChanged:)]) {
                [self.delegate motionDetector:self accelerationChanged:self.acceleration];
            }
#pragma GCC diagnostic pop
            
            
            if (self.accelerationChangedBlock) {
                self.accelerationChangedBlock (self.acceleration);
            }
        });
    }];
    
    if (self.useM7IFAvailable && [MotionDetector motionHardwareAvailable]) {
        if (!self.motionActivityManager) {
            self.motionActivityManager = [[CMMotionActivityManager alloc] init];
        }
        
        [self.motionActivityManager startActivityUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMMotionActivity *activity) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (activity.walking) {
                    _motionType = MotionTypeWalking;
                } else if (activity.running) {
                    _motionType = MotionTypeRunning;
                } else if (activity.automotive) {
                    _motionType = MotionTypeAutomotive;
                } else if (activity.stationary || activity.unknown) {
                    _motionType = MotionTypeNotmoving;
                }
                
                // If type was changed, then call delegate method
                if (self.motionType != self.previousMotionType) {
                    self.previousMotionType = self.motionType;
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
                    if (self.delegate && [self.delegate respondsToSelector:@selector(motionDetector:motionTypeChanged:)]) {
                        [self.delegate motionDetector:self motionTypeChanged:self.motionType];
                    }
#pragma GCC diagnostic pop
                    
                    if (self.motionTypeChangeBlock) {
                        self.motionTypeChangeBlock (self.motionType);
                    }
                }
            });
            
        }];
    }
}

- (void)stopDetection{
    [self.shakeDetectingTimer invalidate];
    self.shakeDetectingTimer = nil;
    
    [[LocationManager sharedInstance] stop];
    [self.motionManager stopAccelerometerUpdates];
    [self.motionActivityManager stopActivityUpdates];
}

#pragma mark - 自定义方法
- (void)setMinimumSpeed:(CGFloat)speed{
    kMinimumSpeed = speed;
    
}

- (void)setMaximumWalkingSpeed:(CGFloat)speed{
    kMaximumWalkingSpeed = speed;
}

- (void)setMaximumRunningSpeed:(CGFloat)speed{
    kMaximumRunningSpeed = speed;
    
}

- (void)setMinimumRunningAcceleration:(CGFloat)acceleration{
    kMinimumRunningAcceleration = acceleration;
}

#pragma mark - 计算运动方式
- (void)calculateMotionType{
    if(self.useM7IFAvailable && [MotionDetector motionHardwareAvailable]){
        return;
    }
    if (_currentSpeed < kMinimumSpeed) {
        _motionType = MotionTypeNotmoving;
    }else if (_currentSpeed <= kMaximumWalkingSpeed){
        _motionType = _isShaking ? MotionTypeRunning : MotionTypeAutomotive;
    }else {
        _motionType = MotionTypeAutomotive;
    }
    
    if (self.motionType != self.previousMotionType) {
        self.previousMotionType = self.motionType;
        
        dispatch_async(dispatch_get_main_queue(), ^{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            if (self.delegate && [self.delegate respondsToSelector:@selector(motionDetector:motionTypeChanged:)]) {
                [self.delegate motionDetector:self motionTypeChanged:self.motionType];
            }
#pragma GCC diagnostic pop
            
            if (self.motionTypeChangeBlock) {
                self.motionTypeChangeBlock (self.motionType);
            }

        });
    }
}

#pragma mark - 检测摇晃
- (void)detectShaking{
    //收集最后一秒的加速度段数组。
    static NSMutableArray * shakeDataForOneSec = nil;
    //一秒中计步数
    static float currentFirngTimeInterval = 0.0f;
    
    currentFirngTimeInterval += 0.01f;
    
    if (currentFirngTimeInterval < 1.0f) {// if one second time intervall not completed yet
        if (!shakeDataForOneSec)
            shakeDataForOneSec = [NSMutableArray array];
        
        // Add current acceleration to array
        NSValue *boxedAcceleration = [NSValue value:&_acceleration withObjCType:@encode(CMAcceleration)];
        [shakeDataForOneSec addObject:boxedAcceleration];
    }
    else
    {
        // Now, when one second was elapsed, calculate shake count in this interval. If there will be at least one shake then
        // we'll determine it as shaked in all this one second interval.
        
        int shakeCount = 0;
        for (NSValue *boxedAcceleration in shakeDataForOneSec) {
            CMAcceleration acceleration;
            [boxedAcceleration getValue:&acceleration];
            
            /*********************************
             *       Detecting shaking
             *********************************/
            double accX_2 = powf(acceleration.x,2);
            double accY_2 = powf(acceleration.y,2);
            double accZ_2 = powf(acceleration.z,2);
            
            double vectorSum = sqrt(accX_2 + accY_2 + accZ_2);
            
            if (vectorSum >= kMinimumRunningAcceleration) {
                shakeCount++;
            }
            /*********************************/
        }
        _isShaking = shakeCount > 0;
        
        shakeDataForOneSec = nil;
        currentFirngTimeInterval = 0.0f;
    }
}

#pragma mark - LocationManager notification handler
- (void)handleLocationChangedNotification:(NSNotification *)note
{
    self.currentLocation = [LocationManager sharedInstance].lastLocation;
    _currentSpeed = self.currentLocation.speed;
    if (_currentSpeed < 0) {
        _currentSpeed = 0;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        if (self.delegate && [self.delegate respondsToSelector:@selector(motionDetector:locationChanged:)]) {
            [self.delegate motionDetector:self locationChanged:self.currentLocation];
        }
#pragma GCC diagnostic pop
        
        if (self.locationChangeBlock) {
            self.locationChangeBlock (self.currentLocation);
        }
    });
    
    [self calculateMotionType];
}

@end
