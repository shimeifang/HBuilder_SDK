//
//  Connection.m
//  HBuilder-Integrate
//
//  Created by admin on 16/9/1.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import "Connection.h"
#import "PDRCoreAppFrame.h"
#import "H5WEEngineExport.h"
#import "PDRToolSystemEx.h"
// 扩展插件中需要引入需要的系统库
#import <LocalAuthentication/LocalAuthentication.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "CDVReachability.h"


@interface Connection(PrivateMethods)

- (void)updateOnlineStatus;
//- (void)sendPluginResult;

@end

@implementation Connection

@synthesize connectionType, internetReach;



#pragma mark 这个方法在使用WebApp方式集成时触发，WebView集成方式不触发

/*
 * WebApp启动时触发
 * 需要在PandoraApi.bundle/feature.plist/注册插件里添加autostart值为true，global项的值设置为true
 */
- (void) onAppStarted:(NSDictionary*)options{
    
    NSLog(@"5+ WebApp启动时触发");
    // 可以在这个方法里向Core注册扩展插件的JS
//    self.connectionType = @"无网络连接";
//    
//    self.internetReach = [CDVReachability reachabilityForInternetConnection];
//    self.connectionType = [self w3cConnectionTypeFor:self.internetReach];
//    [self.internetReach startNotifier];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnectionType:)
//                                                 name:kReachabilityChangedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnectionType:)
//                                                 name:CTRadioAccessTechnologyDidChangeNotification object:nil];
//    if (UIApplicationDidEnterBackgroundNotification && UIApplicationWillEnterForegroundNotification) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPause) name:UIApplicationDidEnterBackgroundNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:UIApplicationWillEnterForegroundNotification object:nil];
//    }

    
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


- (NSData*)PluginConnectionFunction:(PGMethod*)commands{
    
    
    self.connectionType = @"无网络连接";
    self.internetReach = [CDVReachability reachabilityForInternetConnection];
    self.connectionType = [self w3cConnectionTypeFor:self.internetReach];
    [self.internetReach startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnectionType:)
                                                 name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnectionType:)
                                                 name:CTRadioAccessTechnologyDidChangeNotification object:nil];
    if (UIApplicationDidEnterBackgroundNotification && UIApplicationWillEnterForegroundNotification) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPause) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    NSData *data = [self sendPluginResult:self.connectionType];
    return data;
    
    
   
}

- (NSData*)sendPluginResult:(NSString *)str{
    
     NSLog(@"%@",str);
    
//    PDRPluginResult *result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK messageAsString:self.connectionType];
//    
//    
//
   
//
//    // 通知JS层Native层运行结果
//    [self toCallback:_callbackId withReslut:[result toJSONString]];

   return [self resultWithString:str];
    
}

- (NSString*)w3cConnectionTypeFor:(CDVReachability*)reachability
{
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    switch (networkStatus) {
        case NotReachable:
            return @"没有网络连接";
            
        case ReachableViaWWAN:
        {
            BOOL isConnectionRequired = [reachability connectionRequired];
            if (isConnectionRequired) {
                return @"无网络连接";
            } else {
                if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
                    CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
                    if ([telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {
                        return @"当前手机正在耗用您的2G流量";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyEdge]) {
                        return @"当前手机正在耗用您的2G流量";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyWCDMA]) {
                        return @"当前手机正在耗用您的3G流量";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyHSDPA]) {
                        return @"当前手机正在耗用您的3G流量";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyHSUPA]) {
                        return @"当前手机正在耗用您的3G流量";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
                        return @"当前手机正在耗用您的3G流量";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {
                        return @"当前手机正在耗用您的3G流量";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]) {
                        return @"当前手机正在耗用您的3G流量";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
                        return @"当前手机正在耗用您的3G流量";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyeHRPD]) {
                        return @"当前手机正在耗用您的3G流量";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyLTE]) {
                        return @"当前手机正在耗用您的4G流量";
                    }
                }
                return @"cellular";
            }
        }
        case ReachableViaWiFi:
            return @"当前手机连接的是 WiFi";
            
        default:
            return @"unknown";
    }
}

- (BOOL)isCellularConnection:(NSString*)theConnectionType
{
    return [theConnectionType isEqualToString:@"当前手机正在耗用您的2G流量"] ||
    [theConnectionType isEqualToString:@"当前手机正在耗用您的3G流量"] ||
    [theConnectionType isEqualToString:@"当前手机正在耗用您的4G流量"] ||
    [theConnectionType isEqualToString:@"cellular"];
}

- (void)updateReachability:(CDVReachability*)reachability
{
    if (reachability) {
        // check whether the connection type has changed
        NSString* newConnectionType = [self w3cConnectionTypeFor:reachability];
        if ([newConnectionType isEqualToString:self.connectionType]) { // the same as before, remove dupes
            return;
        } else {
            self.connectionType = [self w3cConnectionTypeFor:reachability];
        }
    }

   
    [self sendPluginResult:self.connectionType];
}

- (void)updateConnectionType:(NSNotification*)note
{
    CDVReachability* curReach = [note object];
    
    if ((curReach != nil) && [curReach isKindOfClass:[CDVReachability class]]) {
        [self updateReachability:curReach];
    }
}

- (void)onPause
{
    [self.internetReach stopNotifier];
}

- (void)onResume
{
    [self.internetReach startNotifier];
    [self updateReachability:self.internetReach];
}




-(PDRPluginResult*) init{
    
    self.connectionType = @"无网络连接";
    
    PDRPluginResult *result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK messageAsString:self.connectionType];
    
    self.internetReach = [CDVReachability reachabilityForInternetConnection];
    self.connectionType = [self w3cConnectionTypeFor:self.internetReach];
    [self.internetReach startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnectionType:)
                                                 name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnectionType:)
                                                 name:CTRadioAccessTechnologyDidChangeNotification object:nil];
    if (UIApplicationDidEnterBackgroundNotification && UIApplicationWillEnterForegroundNotification) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPause) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    return result;
}




@end
