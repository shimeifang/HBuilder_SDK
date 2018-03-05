//
//  LocationPlugin.h
//  HBuilder-Hello
//
//  Created by admin on 16/9/26.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#include "PGPlugin.h"
#include "PGMethod.h"
#import <Foundation/Foundation.h>

@interface LocationResult : PDRPluginResult
{
   
}
 @property (nonatomic, assign) BOOL keepCallback;

@end


@interface LocationPlugin : PGPlugin

- (void)LocationFuction:(PGMethod*)commands;


@end







