//
//  PluginTest.m
//  HBuilder-Hello
//
//  Created by Mac Pro on 14-9-3.
//  Copyright (c) 2014年 DCloud. All rights reserved.
//

#import "BDPushPlugin.h"
#import "PDRCoreAppFrame.h"
#import "H5WEEngineExport.h"
#import "PDRToolSystemEx.h"
// 扩展插件中需要引入需要的系统库
#import <LocalAuthentication/LocalAuthentication.h>
#import "BPush.h"

//static NSDictionary *_luanchOptions = nil;

@interface BDPushPlugin()

@property(nonatomic,copy)NSArray *Arr;

@end

@implementation BDPushPlugin

- (void)PluginTestFunction:(PGMethod*)commands{
    
    
    // CallBackid 异步方法的回调id，H5+ 会根据回调ID通知JS层运行结果成功或者失败
    NSString* cbId = [commands.arguments objectAtIndex:0];
    
    NSString *userId = [BPush getUserId];
    NSString *channelId = [BPush getChannelId];
    
    NSString *callBack = [NSString stringWithFormat:@"%@,%@",userId,channelId];
    
    NSLog(@"userId====%@,channelId=====%@",userId,channelId);
    
    PDRPluginResult *result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK messageAsString:callBack];
    
    // 通知JS层Native层运行结果
    [self toCallback:cbId withReslut:[result toJSONString]];
    
}


@end
