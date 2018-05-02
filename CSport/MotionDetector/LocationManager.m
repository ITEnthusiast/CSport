//
//  LocationManager.m
//  MotionDetection
//
//  Created by qianfeng on 16/2/19.
//  Copyright © 2016年 caopei. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

- (id)init{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;//desiredAccuracy想要的精度
        //distanceFilter 距离过滤器
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.delegate = self;
        self.locationType = LocationManagerTypeNone;
    }
    return self;
}

+ (LocationManager *)sharedInstance{
    __strong static LocationManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)start{
    [self.locationManager startUpdatingLocation];
    if (self.locationType == LocationManagerTypeNone)
    {
        self.locationType = LocationManagerTypeStandart;
    }else if(self.locationType == LocationManagerTypeSignificant){
        self.locationType = LocationManagerTypeSignificant | LocationManagerTypeStandart;
    }
}

- (void)startSignificant{
    //startMonitoringSignificantLocationChanges开始重要的监控改变
    [self.locationManager startMonitoringSignificantLocationChanges];
    
    if (self.locationType == LocationManagerTypeNone) {
        self.locationType = LocationManagerTypeSignificant;
    }else if(self.locationType == LocationManagerTypeStandart){
        self.locationType = LocationManagerTypeStandart | LocationManagerTypeSignificant;
    }
}

- (void)stop{
    [self.locationManager stopUpdatingLocation];
    
    if (self.locationType & LocationManagerTypeSignificant) {
        self.locationType = LocationManagerTypeSignificant;
    }
    else{
        self.locationType = LocationManagerTypeNone;
    }
}

- (void)stopSignificant{
    [self.locationManager stopMonitoringSignificantLocationChanges];
    if (self.locationType & LocationManagerTypeStandart) {
        self.locationType = LocationManagerTypeStandart;
    }else{
        self.locationType = LocationManagerTypeNone;
    }

}

#pragma mark - 获取到位置数据
//返回的是一个CLLocation的数组
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation * location = [locations lastObject];
    self.lastLocation = location;
    self.lastCoordinate = location.coordinate;
    [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_DID_CHANGED_NOTIFICATION object:location userInfo:@{@"location":location}];
}

#pragma mark - 获取用户位置数据失败的回调方法，在此通知用户
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error{
    [[NSNotificationCenter defaultCenter]postNotificationName:LOCATION_DID_FAILED_NOTIFICATION object:error userInfo:@{@"error":error}];
}

#pragma mark - 授权状态
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    //kCLAuthorizationStatusNotDetermined授权状态不确定
    if (status == kCLAuthorizationStatusNotDetermined && [self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:LOCATION_AUTHORIZATION_STATUS_CHANGED_NOTIFICATION object:self userInfo:@{@"status":@(status)}];
    
}
@end
