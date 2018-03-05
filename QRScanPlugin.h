//
//  QRScanPlugin.h
//  HBuilder-Integrate
//
//  Created by admin on 16/12/12.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#include "PGPlugin.h"
#include "PGMethod.h"
#import <Foundation/Foundation.h>

@interface QRScanPlugin : PGPlugin

- (void)callScanPlugin:(PGMethod*)command;

//- (void)callbackresult:(PGMethod*)command;

@end
