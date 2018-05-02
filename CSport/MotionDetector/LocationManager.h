//
//  LocationManager.h
//  MotionDetection
//
//  Created by qianfeng on 16/2/19.
//  Copyright © 2016年 caopei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define LOCATION_DID_CHANGED_NOTIFICATION @"LOCATION_DID_CHANGED_NOTIFICATION"//location_did_changed_notification

#define LOCATION_DID_FAILED_NOTIFICATION @"LOCATION_DID_FAILED_NOTIFICATION"//location_did_failed_notification

#define LOCATION_AUTHORIZATION_STATUS_CHANGED_NOTIFICATION @"LOCATION_AUTHORIZATION_STATUS_CHANGED_NOTIFICATION"//location_authorization_status_changed_notification

typedef enum {
    LocationManagerTypeNone = 0x00,
    LocationManagerTypeStandart = 0x10,
    LocationManagerTypeSignificant = 0x10,
    LocationManagerTypeStandartAndSignificant = 0x11
}LocationManagerType;

@interface LocationManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic,strong)CLLocationManager * locationManager;
//CLLocation用来表示某个位置的地理信息，比如经纬度、海拔等等
@property (nonatomic,strong)CLLocation * lastLocation;
//CLLocationCoordinate2D是一个用来表示经纬度的结构体
@property (nonatomic)CLLocationCoordinate2D lastCoordinate;

+ (LocationManager *)sharedInstance;

@property (nonatomic)LocationManagerType locationType;

/**
 * Start Location Update
 */
- (void)start;

- (void)startSignificant;

- (void)stop;

- (void)stopSignificant;

@end
