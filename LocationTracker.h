//
//  LocationTracker.h
//  HBuilder-Integrate
//
//  Created by admin on 16/12/13.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#include "PGPlugin.h"
#include "PGMethod.h"
#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
#import "LocationShareModel.h"

@interface LocationTracker : PGPlugin<CLLocationManagerDelegate>
{
    NSURLSession *_session;
  
    
    NSMutableDictionary *_dicContent;
    
}
@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;

@property (strong,nonatomic) LocationShareModel * shareModel;

@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;

@property (nonatomic,copy) NSTimer* locationUpdateTimer;

+ (CLLocationManager *)sharedLocationManager;

//- (void)startLocationTracking; //开始追踪定位，之后，定位功能就跑起来了
- (void)stopLocationTracking;  //关闭定位追踪
- (void)updateLocationToServer;  //向服务器发送已获取的设备位置信息。

- (void)LocationTrackerPlugin:(PGMethod*)command;


@end
