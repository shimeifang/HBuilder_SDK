//
//  LocationPlugin.m
//  HBuilder-Hello
//
//  Created by admin on 16/9/26.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import "LocationPlugin.h"
#import "PDRCoreAppFrame.h"
#import "H5WEEngineExport.h"
#import "PDRToolSystemEx.h"
// 扩展插件中需要引入需要的系统库
#import <LocalAuthentication/LocalAuthentication.h>

#import <CoreLocation/CoreLocation.h>

@interface LocationPlugin()<CLLocationManagerDelegate>
{
     CLLocationManager *_locationManager;
    
     PDRPluginResult *_result;
     NSString *_callback;
    
    NSMutableArray *_mutArr;
    
   
}
@end

@implementation LocationPlugin

/*
 * WebApp启动时触发
 * 需要在PandoraApi.bundle/feature.plist/注册插件里添加autostart值为true，global项的值设置为true
 */
- (void) onAppStarted:(NSDictionary*)options{
    
    NSLog(@"5+ WebApp启动时触发");
  
    _locationManager = [[CLLocationManager alloc]init];
    
    
//        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)] || [_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {  //iOS 8.0+
//    
//            [_locationManager requestAlwaysAuthorization];
//            [_locationManager requestWhenInUseAuthorization];
//        }
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    _locationManager.delegate = self;
    
    [_locationManager requestAlwaysAuthorization];
    [_locationManager requestWhenInUseAuthorization];
    
    _locationManager.distanceFilter = 10;
    
//        [_locationManager setPausesLocationUpdatesAutomatically:YES];
//        if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0) {
//            [_locationManager setAllowsBackgroundLocationUpdates:YES];
//        }
       [_locationManager startUpdatingLocation];

    
}

// 监听基座事件事件
// 应用退出时触发
- (void) onAppTerminate{
    //
    NSLog(@"APPDelegate applicationWillTerminate 事件触发时触发");
}

// 应用进入后台时触发
- (void) onAppEnterBackground{
    
    NSLog(@"APPDelegate applicationDidEnterBackground 事件触发时触发");
}

// 应用进入前天时触发
- (void) onAppEnterForeground{
    //
    NSLog(@"APPDelegate applicationWillEnterForeground 事件触发时触发");
}


- (void)LocationFuction:(PGMethod*)commands{
    
    _callback = [commands.arguments objectAtIndex:0];
    NSLog(@"--_mutArr12====-%@",_mutArr);
    
    _result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK messageAsArray:_mutArr];

    [self toCallback:_callback withReslut:[_result toJSONString]];
    [_mutArr removeAllObjects];
    
    [self Location];

    

}

- (void)Location{
    
    _locationManager = [[CLLocationManager alloc]init];
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    _locationManager.delegate = self;
    
    [_locationManager requestAlwaysAuthorization];
    [_locationManager requestWhenInUseAuthorization];
    
    _locationManager.distanceFilter = 10;
    [_locationManager startUpdatingLocation];
    
    _result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK messageAsArray:_mutArr];
    
    [self toCallback:_callback withReslut:[_result toJSONString]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"%@",locations);
   
      _mutArr = [[NSMutableArray alloc]init];
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    
//    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    
//     NSLog(@"经度：%f,纬度：%f",coordinate.longitude,coordinate.latitude);
    
    float longitude = coordinate.longitude;
    float latitude = coordinate.latitude;
    
//    [self writeJavascript:[NSString stringWithFormat:@"postStr('%f','%f')",longitude,latitude]];
  
    [_mutArr addObject:[NSString stringWithFormat:@"%f",longitude]];
    [_mutArr addObject:[NSString stringWithFormat:@"%f",latitude]];
     NSLog(@"--_mutArr11---%@",_mutArr);
 [_locationManager stopUpdatingLocation];
    
  
  
}





@end
