//
//  PluginTest.m
//  HBuilder-Hello
//
//  Created by Mac Pro on 14-9-3.
//  Copyright (c) 2014年 DCloud. All rights reserved.
//

#import "MapPluginTest.h"
#import "PDRCoreAppFrame.h"
#import "H5WEEngineExport.h"
#import "PDRToolSystemEx.h"
// 扩展插件中需要引入需要的系统库
#import <LocalAuthentication/LocalAuthentication.h>

#define GDMapUrl @"iosamap://path?sourceApplication=zto&sid=BGVIS1&slat=""&slon=""&sname=我的位置&did=BGVIS2&dlat=""&dlon=""&dname=浦东新区&dev=0&m=0&t=0"
#define BDMapUrl @"baidumap://map/direction?origin={{我的位置}}&destination=浦东新区&mode=driving&region=上海"
#define TXMapUrl @"qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&tocoord=21.02564,36.5648&coord_type=1&policy=0"

@interface PGPluginTest()

@property(nonatomic,copy)NSArray *Arr;

@end

@implementation PGPluginTest



#pragma mark 这个方法在使用WebApp方式集成时触发，WebView集成方式不触发

/*
 * WebApp启动时触发
 * 需要在PandoraApi.bundle/feature.plist/注册插件里添加autostart值为true，global项的值设置为true
 */
- (void) onAppStarted:(NSDictionary*)options{
   
    NSLog(@"5+ WebApp启动时触发");
    // 可以在这个方法里向Core注册扩展插件的JS
    
}

// 监听基座事件事件
// 应用退出时触发
- (void) onAppTerminate{
    //
    NSLog(@"APPDelegate applicationWillTerminate 事件触发时触发");
}

// 应用进入后台时触发
- (void) onAppEnterBackground{
    //
    NSLog(@"APPDelegate applicationDidEnterBackground 事件触发时触发");
}

// 应用进入前天时触发
- (void) onAppEnterForeground{
    //
    NSLog(@"APPDelegate applicationWillEnterForeground 事件触发时触发");
}

#pragma mark 以下为插件方法，由JS触发， WebView集成和WebApp集成都可以触发


- (void)PluginTestFunction:(PGMethod*)commands
{
	if ( commands ) {
        // CallBackid 异步方法的回调id，H5+ 会根据回调ID通知JS层运行结果成功或者失败
        NSString* cbId = [commands.arguments objectAtIndex:0];
        
        
        _Arr = [NSArray arrayWithArray:[self getInstalledMapAppWithEndLocation]];
        
        
        //没有安装地图的时候
        
        if (_Arr.count==0) {
            UIAlertController *alertContrl = [UIAlertController alertControllerWithTitle:@"检测到您当前的手机上还没有安装地图" message:@"请问是否安装如下的地图类型" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *OK1 = [UIAlertAction actionWithTitle:@"安装百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app//id452186370?mt=8"]];
                
            }];
            
            UIAlertAction *OK2 = [UIAlertAction actionWithTitle:@"安装高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app//id461703208?mt=8"]];
                
            }];
            
            UIAlertAction *OK3 = [UIAlertAction actionWithTitle:@"安装腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app//id481623196?mt=8"]];
                
            }];
            
            
            UIAlertAction *canncel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"-----点击取消了-------");
            }];
            [alertContrl addAction:OK1];
            [alertContrl addAction:OK2];
            [alertContrl addAction:OK3];
            [alertContrl addAction:canncel];
            [self presentViewController:alertContrl animated:YES completion:nil];
        }
        
        //    当前手机上安装1个地图的时候
        
        if (_Arr.count>0 && _Arr.count<2) {
            
            UIAlertController *alertControl1 = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"检测到您当前手机上已安装：\n%@",_Arr[0][@"title"]] message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            if ([_Arr[0][@"title"] isEqualToString:@"百度地图"]) {
                UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击百度地图跳转1");
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[BDMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                }];
                [alertControl1 addAction:okAction1];
            }else if ([_Arr[0][@"title"] isEqualToString:@"高德地图"]) {
                UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击高德地图跳转1");
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[GDMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                }];
                
                [alertControl1 addAction:okAction2];
            }else if ([_Arr[0][@"title"] isEqualToString:@"腾讯地图"]) {
                UIAlertAction *okAction3 = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击腾讯地图跳转1");
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[TXMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                }];
                
                [alertControl1 addAction:okAction3];
            }
            UIAlertAction *canncel1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"-----cancel取消-------");
            }];
            
            [alertControl1 addAction:canncel1];
            
            [self presentViewController:alertControl1 animated:YES completion:nil];
        }
        
        //   当地图类型个数在两个的时候促发
        
        if (_Arr.count==2) {
            
            UIAlertController *alertControl2 = [UIAlertController alertControllerWithTitle:@"请选择您要使用的地图类型" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            
            for (NSInteger i=0; i<_Arr.count+1; i++) {
                NSLog(@"%ld,%@",i,_Arr[i][@"title"]);
                
                if ([_Arr[i][@"title"] isEqualToString:@"百度地图"]) {
                    
                    UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:_Arr[i][@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"点击百度地图跳转2");
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[BDMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                    }];
                    [alertControl2 addAction:okAction2];
                    
                }else
                
                if ([_Arr[i][@"title"] isEqualToString:@"高德地图"]) {
                    UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:_Arr[i][@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"点击高德地图跳转2");
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[GDMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                    }];
                    
                    [alertControl2 addAction:okAction2];
                    
                }else
                
                if ([_Arr[i][@"title"] isEqualToString:@"腾讯地图"]) {
                    NSLog(@"点击腾讯地图跳转2");
                    
                    UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:_Arr[i][@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"点击腾讯地图跳转2");
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[TXMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                    }];
                    
                    [alertControl2 addAction:okAction2];
                    
                }
                
                UIAlertAction *canncel2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"-----cancel取消-------");
                }];
                
                [alertControl2 addAction:canncel2];
                [self presentViewController:alertControl2 animated:YES completion:nil];
                
            }
        }
        
        //   当地图类型个数在两个以上的时候促发
        
        if (_Arr.count>2) {
            
            UIAlertController *alertControl3 = [UIAlertController alertControllerWithTitle:@"请选择您要使用的地图类型" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            
            if ([_Arr[0][@"title"] isEqualToString:@"百度地图"]) {
                
                UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:_Arr[0][@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击百度地图跳转2");
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[BDMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                }];
                [alertControl3 addAction:okAction1];
                
            }
            
            if ([_Arr[1][@"title"] isEqualToString:@"高德地图"]) {
                UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:_Arr[1][@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击高德地图跳转2");
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[GDMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                }];
                
                [alertControl3 addAction:okAction2];
                
            }
            
            if ([_Arr[2][@"title"] isEqualToString:@"腾讯地图"]) {
                NSLog(@"点击腾讯地图跳转2");
                
                UIAlertAction *okAction3 = [UIAlertAction actionWithTitle:_Arr[2][@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击腾讯地图跳转2");
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[TXMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                }];
                
                [alertControl3 addAction:okAction3];
                
            }
            
            UIAlertAction *canncel3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"-----cancel取消-------");
            }];
            
            [alertControl3 addAction:canncel3];
            [self presentViewController:alertControl3 animated:YES completion:nil];
            
            
        }

        
         PDRPluginResult *result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK];

        // 通知JS层Native层运行结果
        [self toCallback:cbId withReslut:[result toJSONString]];
    }
}

#pragma mark - 导航方法
- (NSArray *)getInstalledMapAppWithEndLocation
{
    
    NSMutableArray *maps = [NSMutableArray array];
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        [maps addObject:baiduMapDic];
        
    }
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        [maps addObject:gaodeMapDic];
        
    }
    
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        [maps addObject:qqMapDic];
        
        
    }
    
    return [maps copy];
}



@end
