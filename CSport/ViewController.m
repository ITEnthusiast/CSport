//
//  ViewController.m
//  CSport
//
//  Created by MacBook Pro on 2018/4/28.
//  Copyright © 2018年 caopei. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <Masonry.h>

#import "MotionDetector.h"
#import "StepDetector.h"

#import "CPInfoView.h"
#import "CPUserModel.h"
#import "CPAnnotation.h"

#import "CPLoginVC.h"

#define k_NavPolyLine @"navPolyLine"
#define k_PolyLine @"polyLine"

@interface ViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *localManager;

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MKUserLocation *userLocation;
@property (nonatomic, strong) UIButton *locationView;
@property (nonatomic, strong) CPInfoView *infoView;
@property (nonatomic, assign) CGFloat infoView_y;
@property (nonatomic, assign) NSInteger stepCount;
@property (nonatomic, assign) BOOL isStart;
@property (nonatomic, assign) BOOL isRest;
@property (nonatomic, assign) CGFloat currentSpeed;
@property (nonatomic, assign) CGFloat distance;

@property (nonatomic, strong) NSMutableArray *coordinateStr_Arr;
@property (nonatomic, strong) NSMutableArray *polyLine_Arr;
@property (nonatomic, assign) BOOL isStartLine;

@property (nonatomic, strong) id<MKAnnotation> navAnnotation;
@property (nonatomic, strong) MKPolyline *navPolyLine;

@end

@implementation ViewController
CFAbsoluteTime _StartTime;
CFAbsoluteTime _EndTime;

-(CLLocationManager *)localManager {
    if (!_localManager) {
        _localManager = [[CLLocationManager alloc] init];
        [_localManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _localManager.delegate = self;
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined && [_localManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_localManager requestAlwaysAuthorization];
        }
    }
    return _localManager;
}

-(MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        _mapView.mapType = MKMapTypeStandard;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
        
        // 《长按添加大头针》
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(setUpAnnotation:)];
        [_mapView addGestureRecognizer:longPressGesture];
    }
    return _mapView;
}

-(CPInfoView *)infoView {
    if (!_infoView) {
        _infoView_y = k_Layout_Screen_Height-k_NavigitionBar_Height;
        _infoView = [[CPInfoView alloc] initWithFrame:CGRectMake(0, _infoView_y, k_Layout_Screen_Width, k_Layout_Screen_Height*0.6) callBack:^(CPActionType actionType) {
            switch (actionType) {
                    // 响应用户退出账户
                case CPActionTypeLogOut: {
                    [MBProgressHUD showSuccessWithMessage:@"LogOut Success"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:k_NotificationUserLogout object:nil];
                }break;
                    // 响应用户登录账户
                case CPActionTypeLogin: {
                    [self showLoginVC];
                }break;
                    // 响应--开始
                case CPActionTypeStart: {
                    NSLog(@"Start");
                    self.isStart = YES;
                    self.isRest = NO;
                    [self reLoadData];
                }break;
                    // 响应--暂停
                case CPActionTypeRest: {
                    NSLog(@"Rest");
                    self.isStart = NO;
                    self.isRest = YES;
                    [self reLoadData];
                }break;
                    // 响应--结束
                case CPActionTypeEnd: {
                    NSLog(@"End");
                    self.isStart = NO;
                    self.isRest = NO;
                    [self reLoadData];
                }break;
            }
        }];
        _infoView.backgroundColor = [UIColor whiteColor];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(showInfoView:)];
        [_infoView addGestureRecognizer:panGesture];
        
    }
    return _infoView;
}

-(UIButton *)locationView {
    if (!_locationView) {
        _locationView = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationView.frame = CGRectMake(k_Layout_Screen_Width-40, 30, 30, 30);
        [_locationView setBackgroundImage:[UIImage imageNamed:@"btn_map_locate"] forState:UIControlStateNormal];
        [_locationView setBackgroundImage:[UIImage imageNamed:@"btn_map_locate_hl"] forState:UIControlStateHighlighted];
        _weak(self);
        [_locationView addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            _strong(self);
            CLLocationCoordinate2D coordinate = self.mapView.userLocation.location.coordinate;
            coordinate.latitude -= 0.002;
            [self.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.005, 0.005)) animated:YES];
        }];
    }
    return _locationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //是否启用定位服务
    if ([CLLocationManager locationServicesEnabled]){
        NSLog(@"开始定位");
        //调用 startUpdatingLocation 方法后,会对应进入 didUpdateLocations 方法
        [self.localManager startUpdatingLocation];
    }
    else{
        NSLog(@"定位服务为关闭状态,无法使用定位服务");
    }
    
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.locationView];
    [self.view addSubview:self.infoView];
    
    
    _weak(self);
    // 监听登录成功
    [self addObserverForNotificationName:k_NotificationUserLoginSuccess usingBlock:^(NSNotification *notification) {
        _strong_check(self);
        // 保存用户信息
        CPUserModel *userModel = notification.object;
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        [userInfo setObject:userModel.nickName forKey:k_CurrentUser];
        [userInfo setObject:userModel.password forKey:k_CurrentPassword];
        [self.infoView updateUserInfo:userModel.nickName password:userModel.password];
    }];
    // 监听退出登录
    [self addObserverForNotificationName:k_NotificationUserLogout usingBlock:^(NSNotification *notification) {
        _strong_check(self);
        // 清除用户记录
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        [userInfo setObject:nil forKey:k_CurrentUser];
        [userInfo setObject:nil forKey:k_CurrentPassword];
        [self.infoView updateUserInfo:nil password:nil];
        
        _isStartLine = NO;
        NSLog(@"End");
        self.isStart = NO;
        self.isRest = NO;
        [self reLoadData];
    }];
}

// 更新InfoView的子控件UI
-(void)reLoadData {
    // 响应--开始
    if (self.isStart && !self.isRest) {
        _StartTime = CFAbsoluteTimeGetCurrent();
        _isStartLine = YES;
        // 传感器开始工作
        [[MotionDetector sharedInstance] startDetection];
        [MotionDetector sharedInstance].locationChangeBlock = ^(CLLocation *location) {
            self.currentSpeed = [MotionDetector sharedInstance].currentSpeed;
            
            if (!self.currentSpeed) return ;
            
            _EndTime = CFAbsoluteTimeGetCurrent();
            self.distance += (_EndTime-_StartTime)*self.currentSpeed;
            NSLog(@"currentSpeed:%.2f,currentTime:%.2f,Distance:%.3f", self.currentSpeed, _EndTime-_StartTime, self.distance/1000);
            [self.infoView updateDistance:self.distance/1000];
            
            // 记录当前时刻的（时间、经纬度）下次使用
            _StartTime = CFAbsoluteTimeGetCurrent();
        };
        
        [[StepDetector sharedInstance] startDetectionWithUpdateBlock:^(NSError *error) {
            if (error) {
                NSLog(@"ERROR:%@", error);
            }
            if (!self.currentSpeed) {
                
                self.distance += 1.2;
                NSLog(@"currentSpeed:%.2f,currentTime:%.2f,Distance:%.3f", 1.5, _EndTime-_StartTime, self.distance/1000);
                [self.infoView updateDistance:self.distance/1000];
            }
            NSLog(@"stepCount:%ld", (long)self.stepCount ++);
            [self.infoView updateStepCount:self.stepCount];
            
        }];
    }
     // 响应--暂停
    if (!self.isStart && self.isRest) {
        _isStartLine = NO;
        // 停止传感器工作
        [[MotionDetector sharedInstance] stopDetection];
        [[StepDetector sharedInstance] stopDetection];
    }
     // 响应--开始结束
    if (!self.isStart && !self.isRest) {
        _isStartLine = NO;
        // 停止传感器工作
        [[MotionDetector sharedInstance] stopDetection];
        [[StepDetector sharedInstance] stopDetection];
        self.stepCount = 0;
        self.distance = 0;
        [self.infoView updateDistance:self.distance];
        [self.infoView updateStepCount:self.stepCount];
        // 清除实时路经画线
        [self deletePolyLine];
        [self deleteNavPolyLineFor:self.navAnnotation];
    }
}

-(void)showInfoView: (UIPanGestureRecognizer *)sender{

    CGPoint point = [sender translationInView:self.infoView];
    if (point.y<0) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.infoView.frame;
            frame.origin.y = k_Layout_Screen_Height*0.4;
            self.infoView.frame = frame;
        }];
    }
    else {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.infoView.frame;
            frame.origin.y = k_Layout_Screen_Height-k_NavigitionBar_Height;
            self.infoView.frame = frame;
        }];
    }
}

-(void)showLoginVC {
    CPLoginVC *loginVC = [[CPLoginVC alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

// 《长按添加大头针》

-(void)setUpAnnotation:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        if (self.navAnnotation) {
            [self deleteNavPolyLineFor:self.navAnnotation];
        }
        
        // 1.获取用户点击的点
        CGPoint point = [sender locationInView:self.view];
        
        // 2.将该点转化成经纬度(地图上的坐标)
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.view];
        
        // 3.添加大头针
        CPAnnotation *annotation = [[CPAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.title = @"Go There";
        [self.mapView addAnnotation:annotation];
    }
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.userLocation = userLocation;
    CLLocation *location = userLocation.location;
    CLLocationCoordinate2D coordinate = location.coordinate;
    CLLocationCoordinate2D coordinate_t = coordinate;
    coordinate_t.latitude -= 0.002;
    NSLog(@"%f,%f", coordinate_t.latitude, coordinate_t.longitude);
    [_mapView setRegion:MKCoordinateRegionMake(coordinate_t, MKCoordinateSpanMake(0.005, 0.005)) animated:YES];
    
    if (_isStartLine) {
        CLLocationCoordinate2D destinationCoordinate = coordinate;
        
        // 实时路经画线
        [self drawLineToDestinationCoordinate:destinationCoordinate];
    }
}

// 《长按添加大头针》
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *ID = @"annoView";
    MKAnnotationView *annoView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    
    self.navAnnotation = annotation;
    
    if (!annoView) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        annoView.enabled = YES;
        annoView.canShowCallout = YES;
        annoView.image = [UIImage imageNamed:@"sports_mode"];
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 20, 20);
        [leftButton setImage:[UIImage imageNamed:@"go_there"] forState:UIControlStateNormal];
        leftButton.showsTouchWhenHighlighted = YES;
        [leftButton addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            if (self.navPolyLine) return ;
            
            // 2.2.利用CLPlacemark来创建MKPlacemark
            MKPlacemark *mkpm = [[MKPlacemark alloc] initWithCoordinate:self.navAnnotation.coordinate];

            // 2.3.创建目的地的MKMapItem对象
            MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:mkpm];
            
            // 2.4.起点的MKMapItem
            MKMapItem *sourceItem = [MKMapItem mapItemForCurrentLocation];
            
            // 2.5.开始画线
            [self drawLineWithSourceItem:sourceItem destinationItem:destinationItem];
        }];
        annoView.leftCalloutAccessoryView = leftButton;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 20, 20);
        [rightButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        rightButton.showsTouchWhenHighlighted = YES;
        [rightButton addControlEvents:UIControlEventTouchUpInside action:^(UIControl *control, NSSet *touches) {
            // 删除导航路经
            [self deleteNavPolyLineFor:self.navAnnotation];
        }];
        annoView.rightCalloutAccessoryView = rightButton;
    }
    annoView.annotation = annotation;
    return annoView;
}

/**
 *  大头针的View已经被添加mapView会执行该方法
 *
 *  @param views   所有大头针的View都存放在该数组中
 */
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //MKModernUserLocationView
    for (MKAnnotationView *annoView in views) {
        // 如果是系统的大头针View直接返回
        if ([annoView.annotation isKindOfClass:[MKUserLocation class]]) return;
        
        // 取出大头针View的最终应该在位置
        CGRect endFrame = annoView.frame;
        
        // 给大头针重新设置一个位置
        annoView.frame = CGRectMake(endFrame.origin.x, 0, endFrame.size.width, endFrame.size.height);
        
        // 执行动画
        [UIView animateWithDuration:0.3 animations:^{
            annoView.frame = endFrame;
        }];
    }
}


/**
 *  实时路径画线
 *
 *  @param destinationCoordinate      终点点的destinationCoordinate
 */
- (void)drawLineToDestinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate {
    if (!self.coordinateStr_Arr) {
        self.coordinateStr_Arr = [NSMutableArray array];
        NSString *coordinateStr = [NSString stringWithFormat:@"%f,%f", destinationCoordinate.latitude, destinationCoordinate.longitude];
        [self.coordinateStr_Arr addObject:coordinateStr];
    }else {
        NSArray *array = [self.coordinateStr_Arr.lastObject componentsSeparatedByString:@","];
        CLLocationCoordinate2D sourceCoordinate;
        NSString *latitudeStr = array[0];
        NSString *longitudeStr = array[1];
        
        sourceCoordinate = CLLocationCoordinate2DMake([latitudeStr doubleValue], [longitudeStr doubleValue]);
        [self drawLineWithSourceCoordinate:sourceCoordinate destinationCoordinate:destinationCoordinate];
    }
}

- (void)drawLineWithSourceCoordinate:(CLLocationCoordinate2D)sourceCoordinate destinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate {
    
    CLLocationCoordinate2D coordinate_Arr[2];
    coordinate_Arr[0] = sourceCoordinate;
    coordinate_Arr[1] = destinationCoordinate;
    
    
    NSString *coordinateStr = [NSString stringWithFormat:@"%f,%f", destinationCoordinate.latitude, destinationCoordinate.longitude];
    [self.coordinateStr_Arr addObject:coordinateStr];
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinate_Arr count:2];
    if (!self.polyLine_Arr) {
        self.polyLine_Arr = [NSMutableArray array];
    }
    polyLine.title = k_PolyLine;
    [self.polyLine_Arr addObject:polyLine];
    [self.mapView addOverlay:polyLine];
    
}

- (void)deletePolyLine{
    
    if (self.polyLine_Arr) {
        [self.mapView removeOverlays:self.polyLine_Arr];
    }
    self.polyLine_Arr = nil;
}

/**
 *  导航路径画线
 *
 *  @param sourceItem      起点的Item
 *  @param destinationItem 终点的Item
 */

- (void)drawLineWithSourceItem:(MKMapItem *)sourceItem destinationItem:(MKMapItem *)destinationItem
{
    // 1.创建MKDirectionsRequest对象
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    // 1.1.设置起点的Item
    request.source = sourceItem;
    
    // 1.2.设置终点的Item
    request.destination = destinationItem;
    
    // 2.创建MKDirections对象
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    // 3.请求/计算(当请求到路线信息的时候会来到该方法)
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        // 3.1.当有错误,或者路线数量为0直接返回
        if (error || response.routes.count == 0) return;
        
        NSLog(@"source:%@\t,destination:%@", response.source, response.destination);
        
        // 3.2.遍历所有的路线
        for (MKRoute *route in response.routes) {
            
            // 3.3.取出路线(遵守MKOverlay)
            MKPolyline *navPolyLine = route.polyline;
            navPolyLine.title = k_NavPolyLine;
            
            self.navPolyLine = navPolyLine;
            
            
            // 3.4.将路线添加到地图上
            [self.mapView addOverlay:self.navPolyLine];
        }
    }];
}

- (void)deleteNavPolyLineFor:(id<MKAnnotation>)annotation {
    
    if (self.navPolyLine) {
        [self.mapView removeOverlay:self.navPolyLine];
        self.navPolyLine = nil;
    }
    [self.mapView removeAnnotation:annotation];
    self.navAnnotation = nil;
}


/**
 *  当一个遮盖添加到地图上时会执行该方法
 *
 *  @param overlay 遵守MKOverlay的对象
 *
 *  @return 画线的渲染
 */
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(MKPolyline *)overlay
{
    
    MKPolylineRenderer *poly = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    
    if ([overlay.title isEqualToString:k_NavPolyLine]) {
        poly.strokeColor = k_COLOR_THEME;
        poly.lineWidth = 8.0;
    }
    else if ([overlay.title isEqualToString:k_PolyLine]) {
        poly.strokeColor = [UIColor redColor];
        poly.lineWidth = 5.0;
    }
    return poly;
}

#pragma mark - CLLocationManagerDelegate
/**
 *  当前定位授权状态发生改变时调用
 *
 *  @param manager 位置管理者
 *  @param status  授权的状态
 */
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:{
            NSLog(@"用户还未进行授权");
            break;
        }
        case kCLAuthorizationStatusDenied:{
            // 判断当前设备是否支持定位和定位服务是否开启
            if([CLLocationManager locationServicesEnabled]){
                
                NSLog(@"用户不允许程序访问位置信息或者手动关闭了位置信息的访问，帮助跳转到设置界面");
                
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL: url];
                }
            }else{
                NSLog(@"定位服务关闭,弹出系统的提示框,点击设置可以跳转到定位服务界面进行定位服务的开启");
            }
            break;
        }
        case kCLAuthorizationStatusRestricted:{
            NSLog(@"受限制的");
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:{
            NSLog(@"授权允许在前台和后台均可使用定位服务");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            NSLog(@"授权允许在前台可使用定位服务");
            break;
        }
            
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 设备的当前位置
    CLLocation *currLocation = [locations lastObject];
    
    NSString *latitude = [NSString stringWithFormat:@"纬度:%3.5f",currLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"经度:%3.5f",currLocation.coordinate.longitude];
    NSString *altitude = [NSString stringWithFormat:@"高度值:%3.5f",currLocation.altitude];
    
    NSLog(@"位置发生改变:纬度:%@,经度:%@,高度:%@",latitude,longitude,altitude);
    
    [manager stopUpdatingLocation];
}

//定位失败的回调方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"无法获取当前位置 error : %@",error.localizedDescription);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
