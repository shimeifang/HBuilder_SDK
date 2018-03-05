//
//  PluginTest.h
//  HBuilder-Hello
//
//  Created by Mac Pro on 14-9-3.
//  Copyright (c) 2014年 DCloud. All rights reserved.
//

#include "PGPlugin.h"
#include "PGMethod.h"
#import <Foundation/Foundation.h>

#define kBDPushPluginReceiveNotification @"BDPushPluginReceiveNofication"

@interface BDPushPlugin : PGPlugin


- (void)PluginTestFunction:(PGMethod*)commands;

@end
