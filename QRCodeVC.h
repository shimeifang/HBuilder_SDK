//
//  QRCodeVC.h
//  shikeApp
//
//  Created by 淘发现4 on 16/1/7.
//  Copyright © 2016年 淘发现1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendDataDelegate <NSObject>

- (void)sendOrders:(NSArray*)arr;

@end

@interface QRCodeVC : UIViewController

@property (nonatomic) BOOL lastResut; //表示是否是第一次扫描成功

@property (nonatomic) BOOL repeatScan; //表示是否连扫

@property(nonatomic)BOOL isnull;//判断扫描结果是否有最新值

@property(nonatomic,assign)id<sendDataDelegate> delegate;

- (void)sendData:(void(^)(NSArray *orders))block;

@end
