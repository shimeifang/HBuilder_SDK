//
//  LocationTracker.m
//  HBuilder-Integrate
//
//  Created by admin on 16/12/13.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import "LocationTracker.h"

#import "PDRCoreAppFrame.h"
#import "H5WEEngineExport.h"
#import "PDRToolSystemEx.h"
// 扩展插件中需要引入需要的系统库
#import <LocalAuthentication/LocalAuthentication.h>

#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define ACCURACY @"theAccuracy"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation LocationTracker
{
   
    
}
+ (CLLocationManager *)sharedLocationManager {
    static CLLocationManager *_locationManager;
    
    @synchronized(self) {
        if (_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            _locationManager.allowsBackgroundLocationUpdates = YES;
            _locationManager.pausesLocationUpdatesAutomatically = NO;
        }
    }
    return _locationManager;
}

- (id)init {
    if (self==[super init]) {
        //Get the share model and also initialize myLocationArray
        self.shareModel = [LocationShareModel sharedModel];
        self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

-(void)applicationEnterBackground{
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    //Use the BackgroundTaskManager to manage all the background Task
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
}

- (void)LocationTrackerPlugin:(PGMethod*)command{
    
    if (command) {
        //进行初始化，插件执行前必须调用；若不是插件则可以不用
        [self init];
        
        NSString *callback = [command.arguments objectAtIndex:0];
        
        if ([CLLocationManager locationServicesEnabled] == NO) {
            NSLog(@"locationServicesEnabled false");
            UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [servicesDisabledAlert show];
        } else {
            CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
            
            if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
                NSLog(@"authorizationStatus failed");
            } else {
                NSLog(@"authorizationStatus authorized");
                CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
                locationManager.delegate = self;
                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
                locationManager.distanceFilter = kCLDistanceFilterNone;
                
                if(IS_OS_8_OR_LATER) {
                    [locationManager requestAlwaysAuthorization];
                }
                [locationManager startUpdatingLocation];
            }
        }
        
//        获取前端要上传的参数，到服务器上
        NSString *arg = [command.arguments objectAtIndex:1];
        NSLog(@"%@",arg);
        
        //设定向服务器发送位置信息的时间间隔
        NSTimeInterval time = 60.0;
        //开启计时器
        self.locationUpdateTimer =
        [NSTimer scheduledTimerWithTimeInterval:time
                                         target:self
                                       selector:@selector(updateLocationToServer)
                                       userInfo:nil
                                        repeats:YES];
        
         PDRPluginResult *result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK messageAsString:@"sucess"];
         result.keepCallback = YES;
         [self toCallback:callback withReslut:[result toJSONString]];
    }

}

- (void) restartLocationUpdates
{
    NSLog(@"restartLocationUpdates");
    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
}



- (void)stopLocationTracking {
    NSLog(@"stopLocationTracking");
    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    [locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"locationManager didUpdateLocations");
    
    for(int i=0;i<locations.count;i++){
        CLLocation * newLocation = [locations objectAtIndex:i];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
        
        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
        
        if (locationAge > 30.0)
        {
            continue;
        }
        
        //只选择有效的准确位置定位
        if(newLocation!=nil&&theAccuracy>0
           &&theAccuracy<2000
           &&(!(theLocation.latitude==0.0&&theLocation.longitude==0.0))){
            
            self.myLastLocation = theLocation;
            self.myLastLocationAccuracy= theAccuracy;
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[NSNumber numberWithFloat:theLocation.latitude] forKey:@"latitude"];
            [dict setObject:[NSNumber numberWithFloat:theLocation.longitude] forKey:@"longitude"];
            [dict setObject:[NSNumber numberWithFloat:theAccuracy] forKey:@"theAccuracy"];
           
            
            //添加准确有效的定位到一个数组中
            //每一分钟,我将基于精度和选择最好的位置发送给服务器
            [self.shareModel.myLocationArray addObject:dict];
        }
    }
    
    //If the timer still valid, return it (Will not run the code below)
    if (self.shareModel.timer) {
        return;
    }
    
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
    
    //1分钟后重启locationMaanger
    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self
                                                           selector:@selector(restartLocationUpdates)
                                                           userInfo:nil
                                                            repeats:NO];
    
    //会停止locationManager 10秒,10秒后,可以得到一些准确的位置
    //位置管理器只会操作10秒钟以节省电池
    if (self.shareModel.delay10Seconds) {
        [self.shareModel.delay10Seconds invalidate];
        self.shareModel.delay10Seconds = nil;
    }
    
    self.shareModel.delay10Seconds = [NSTimer scheduledTimerWithTimeInterval:10 target:self
                                                                    selector:@selector(stopLocationDelayBy10Seconds)
                                                                    userInfo:nil
                                                                     repeats:NO];
    
}


//Stop the locationManager
-(void)stopLocationDelayBy10Seconds{
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    [locationManager stopUpdatingLocation];
    
    NSLog(@"locationManager 10秒后停止更新");
}


- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
     NSLog(@"locationManager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误" message:@"请检查是否连接到网络" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务被关闭" message:@"您必须启用定位服务才能使用该功能,启用请到设置- >隐私- >定位服务中开启" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            
        }
            break;
    }
}


//发送定位到服务器
- (void)updateLocationToServer {
    
    NSLog(@"updateLocationToServer");
    
    // 根据精度从数组中找到最好的位置
    NSMutableDictionary * myBestLocation = [[NSMutableDictionary alloc]init];
    
    for(int i=0;i<self.shareModel.myLocationArray.count;i++){
        NSMutableDictionary * currentLocation = [self.shareModel.myLocationArray objectAtIndex:i];
        
        if(i==0)
            myBestLocation = currentLocation;
        else{
            if([[currentLocation objectForKey:ACCURACY]floatValue]<=[[myBestLocation objectForKey:ACCURACY]floatValue]){
                myBestLocation = currentLocation;
            }
        }
    }
    NSLog(@"My Best location:%@",myBestLocation);
    
    //如果数组是0,得到最后的位置
    //有时由于网络问题或未知的原因,在此期间你不能得到位置,你能做的最好的就是把最后已知位置发送到服务器
    if(self.shareModel.myLocationArray.count==0)
    {
        NSLog(@"Unable to get location, use the last known location");
        
        self.myLocation=self.myLastLocation;
        self.myLocationAccuracy=self.myLastLocationAccuracy;
        
    }else{
        CLLocationCoordinate2D theBestLocation;
        theBestLocation.latitude =[[myBestLocation objectForKey:LATITUDE]floatValue];
        theBestLocation.longitude =[[myBestLocation objectForKey:LONGITUDE]floatValue];
        self.myLocation=theBestLocation;
        self.myLocationAccuracy =[[myBestLocation objectForKey:ACCURACY]floatValue];
    }
    
    NSLog(@"Send to Server: Latitude(%f) Longitude(%f) Accuracy(%f)",self.myLocation.latitude, self.myLocation.longitude,self.myLocationAccuracy);
    
    //TODO: 在这里插入你向服务器发送定位信息请求的代码
    //----------------------------------向服务器发送请求的代码------------------------------------------------------
    NSError *error;
    NSURL *url = [NSURL URLWithString:@"http://112.124.36.112:8900/Receive.aspx"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *parameters = @{@"RequestName":@"RequestVehicleTrack",@"ComCode":@"agfadad5641sad", @"Sign":@"sdfs4524ds1f6a546e",@"TimeStamp":@"a6c8256a9agvnrtru9a56w",@"Content":@"36.0,564.0"};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    
    [request setHTTPBody:postData];
    
    _session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //        NSLog(@"response:%@",response);
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"----%@", dict);
        
    }];
    
    [task resume];
    
    
   
  
    //当你向服务器发送位置信息成功后，要清空当前的数组，以便下一回合的定位
    [self.shareModel.myLocationArray removeAllObjects];
    self.shareModel.myLocationArray = nil;
    self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
}




@end
