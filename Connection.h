//
//  Connection.h
//  HBuilder-Integrate
//
//  Created by admin on 16/9/1.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#include "PGPlugin.h"
#include "PGMethod.h"
#import <Foundation/Foundation.h>

#import "CDVReachability.h"

@interface Connection : PGPlugin
{
    NSString* type;
    NSString* _callbackId;
    
    CDVReachability* internetReach;
}

@property (copy) NSString* connectionType;
@property (strong) CDVReachability* internetReach;

//- (void)PluginConnectionFunction:(PGMethod*)commands;

- (NSData*)PluginConnectionFunction:(PGMethod*)commands;

@end
