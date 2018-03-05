//
//  BTPrinterPlugin.h
//  HBuilder-Integrate
//
//  Created by admin on 16/10/19.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#include "PGPlugin.h"
#include "PGMethod.h"
#import <Foundation/Foundation.h>

@interface BTPrinterPlugin : PGPlugin

- (void)BTPrinterFunction:(PGMethod*)command;

- (NSData*)PluginTestFunctionSync:(PGMethod*)command;
- (NSData*)PluginTestFunctionSyncArrayArgu:(PGMethod*)command;

@end
