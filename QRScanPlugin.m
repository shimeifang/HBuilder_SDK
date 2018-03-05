//
//  QRScanPlugin.m
//  HBuilder-Integrate
//
//  Created by admin on 16/12/12.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import "QRScanPlugin.h"
#import "PDRCoreAppFrame.h"
#import "H5WEEngineExport.h"
#import "PDRToolSystemEx.h"
// 扩展插件中需要引入需要的系统库
#import <LocalAuthentication/LocalAuthentication.h>

#import "QRCodeVC.h"

@interface QRScanPlugin()<sendDataDelegate>
{
    PDRPluginResult *result;
    NSString *callback;
    NSArray *_arr;
    NSMutableDictionary *_dic;
}

@end

@implementation QRScanPlugin

- (void)callScanPlugin:(PGMethod*)command{
    if (command) {
       
        callback = [command.arguments objectAtIndex:0];
        
        [self callScanVC];
        
        
         result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK];
        [self toCallback:callback withReslut:[result toJSONString]];
       
        
    }
}

- (void)callScanVC{
    
    
    QRCodeVC *scanVC = [[QRCodeVC alloc]init];
    scanVC.delegate = self;
    
    [self presentViewController:scanVC animated:YES completion:nil];


    

}

//- (void)havaResult{
//    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
//    result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK messageAsArray:[userData objectForKey:@"results"]];
//    
//}

- (void)sendOrders:(NSArray *)arr{
   
    NSLog(@"----------======%@",arr);
    NSLog(@"%@",[NSString stringWithFormat:@"getOrders(%@)",arr]);
 
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
   
    [dictionary setValue:arr forKey:@"orders"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr==%@",jsonStr);
   
    [self writeJavascript:[NSString stringWithFormat:@"getOrders(%@)",jsonStr]];

}

@end
