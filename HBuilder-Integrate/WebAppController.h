//
//  WebAppController.h
//  HBuilder-Integrate
//
//  Created by EICAPITAN on 16/5/12.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDRCore.h"
#import "PDRCoreAppWindow.h"


@interface WebAppController : UIViewController<PDRCoreDelegate,PDRCoreAppWindowDelegate>
{
    UIStatusBarStyle _statusBarStyle;
    BOOL _isFullScreen;
    UIView *_containerView;
    UIView *_statusBarView;
}

@property(nonatomic, retain)UIColor *defalutStausBarColor;
-(UIColor*)getStatusBarBackground;
@end
