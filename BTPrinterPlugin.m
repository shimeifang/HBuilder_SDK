//
//  BTPrinterPlugin.m
//  HBuilder-Integrate
//
//  Created by admin on 16/10/19.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import "BTPrinterPlugin.h"
#import "PDRCoreAppFrame.h"
#import "H5WEEngineExport.h"
#import "PDRToolSystemEx.h"
// 扩展插件中需要引入需要的系统库
#import <LocalAuthentication/LocalAuthentication.h>


#import "OneViewController.h"

@implementation BTPrinterPlugin

- (void)BTPrinterFunction:(PGMethod*)command{
   
    if (command) {
        NSString *callback = [command.arguments objectAtIndex:0];
        NSString *arg = [command.arguments objectAtIndex:1];
        NSLog(@"%@",arg);
        PDRPluginResult *result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK messageAsString:@"sucess"];
       
        [self toCallback:callback withReslut:[result toJSONString]];
        
        OneViewController *onevc = [[OneViewController alloc]init];
        [self presentViewController:onevc animated:YES completion:nil];
        
    }
}

- (NSData*)PluginTestFunctionSync:(PGMethod*)command
{
    NSLog(@"8");
    // 根据传入获取参数
        NSString* pArgument = [command.arguments objectAtIndex:0];
    //
    //
    //
    //    // 拼接成字符串
        NSString* pResultString = [NSString stringWithFormat:@"%@", pArgument];
    
    // 按照字符串方式返回结果
    return [self resultWithString: pResultString];
}


- (NSData*)PluginTestFunctionSyncArrayArgu:(PGMethod*)command
{
    // 根据传入参数获取一个Array，可以从中获取参数
    NSArray* pArray = [command.arguments objectAtIndex:0];
    
    // 创建一个作为返回值的NSDictionary
    NSDictionary* pResultDic = [NSDictionary dictionaryWithObjects:pArray forKeys:[NSArray arrayWithObjects:@"RetArgu1",@"RetArgu2",@"RetArgu3", @"RetArgu4", nil]];
    
    // 返回类型为JSON，JS层在取值是需要按照JSON进行获取
    return [self resultWithJSON: pResultDic];
}
@end
